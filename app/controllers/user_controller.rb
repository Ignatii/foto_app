class UserController < ApplicationController

  def show
    @user = User.find(params[:id])
    @images = @user.images.first
  end
  
  def index
    @users = User.all
  end

  def new
    #@user = User.find(params[:id])
  end
end
