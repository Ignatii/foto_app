require 'open-uri'

# users controller for app
class UserController < ProxyController
  def show
    @user = User.find(current_user.id)
    return if current_user.insta_token.nil?
    # hash_user = {user: current_user}
    result = ShowUsersInsta.run(user: current_user)
    res = result.valid?
    @insta_images = result.result ifres
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
    result = UpdateUsersInsta.run(user: current_user,
                                  token_insta: params['token_insta'])
    res = result.valid?
    flash[:warning] = result.errors.full_messages.to_sentence unless res
    flash[:success] = result.result if res
    redirect_to current_user
  end
end
