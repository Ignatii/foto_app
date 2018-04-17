require 'open-uri'

# users controller for app
class UserController < ProxyController
  def show
    @user = current_user
    return if @user.insta_token.blank?
    result = Images::ShowUsersInsta.run(user: current_user)
    @insta_images = result.valid? ? result.result : []
    flash[:warning] = result.errors.full_messages.to_sentence unless result.valid?
  end

  def index
    @users = User.all
  end

  def new
  end

  def update
    redirect_to current_user && return if params['token_insta'].empty?
    result = Images::UpdateUsersInsta.run(user: current_user,
                                          token_insta: params['token_insta'])
    err_str = result.errors.full_messages.to_sentence
    flash = result.valid? ? { success: result.result } : { warning: err_str }
    redirect_to current_user, flash: flash
  end
end
