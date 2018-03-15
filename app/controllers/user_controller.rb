class UserController < ProxyController

  def show
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.all
  end

  def new
    #@user = User.find(params[:id])
  end
end
