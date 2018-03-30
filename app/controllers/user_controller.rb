require 'open-uri'

# users controller for app
class UserController < ProxyController
  def show
    @user = User.find(current_user.id)
    return if current_user.insta_token.nil?
    # hash_user = {user: current_user}
    result = ShowUsersInsta.run(user: current_user)
    @insta_images = result.result if result.result
  end

  def index
    @users = User.all
  end

  def new
    # @user = User.find(params[:id])
  end

  def update
  	redirect_to current_user and return if params['token_insta'].empty?
    result = UpdateUsersInsta.run(user: current_user, token_insta: params['token_insta'])
    if result.result
      flash[:success] = 'Your photos from instagram successfully added'
    else
      flash[:warning] = 'Problem with adding your instagram photos. Try later or contact admin'
    end
    redirect_to current_user
  end
end
