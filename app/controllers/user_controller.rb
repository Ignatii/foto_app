require 'open-uri'

# users controller for app
class UserController < ProxyController
  def show
    @user = User.find(current_user.id)
    return if current_user.insta_token.nil?
    # hash_user = {user: current_user}
    result = Images::ShowUsersInsta.run(user: current_user)
    res = result.valid?
    @insta_images = result.result if res
    flash[:warning] = result.errors.full_messages.to_sentence unless res
  end

  def index
    @users = User.all
  end

  def new
    # @user = User.find(params[:id])
  end

  def update
    redirect_to current_user && return if params['token_insta'].empty?
    result = Images::UpdateUsersInsta.run(user: current_user,
                                          token_insta: params['token_insta'])
    res = result.valid?
    err_str = result.errors.full_messages.to_sentence
    m = { flash: res ? { success: result.result } : { warning: err_str } }
    redirect_to current_user, flash: m[:flash]
  end
end
