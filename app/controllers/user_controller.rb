require 'open-uri'

# users controller for app
class UserController < ProxyController
  def show
    @user = User.find(current_user.id)
    if !current_user.insta_token.empty?
      begin
      response = open("https://api.instagram.com/v1/users/self/media/recent/?access_token=#{current_user.insta_token}&count=12").read
      #res = open("https://api.instagram.com/v1/users/self/media/recent/?access_token=4088921481.a999fd0.64eec4699bd1882946ec2d8762e1&count=12").read
      response_parsed = JSON.parse response
      @insta_images = response_parsed["data"]
      rescue OpenURI::HTTPError
      	current_user.update_attributes(insta_token: '')
      	flash[:warning] = 'Your authentification for Instagram was denied! Please sign in again'
      end
    end
    #if params[:id] != current_user.id
    #	redirect_to current_user
    #end
  end

  def index
    @users = User.all
  end

  def new
    # @user = User.find(params[:id])
  end

  def update
  	if !params['token_insta'].empty?
      @token = params['token_insta'].split('en=')
      @user = User.find_by(id: current_user.id)
      @user.update_attributes(insta_token: @token[1])
      redirect_to current_user
    end
  end
end
