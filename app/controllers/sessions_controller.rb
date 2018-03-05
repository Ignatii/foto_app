class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)
    if user.valid?
      session[:user_id] = user.id
      redirect_to user
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
