# session controller app
class SessionsController < ApplicationController
  # skip_before_action :check_current_user
  # skip_before_action :check_banned_user

  #def create
  #  auth = request.env['omniauth.auth']
  #  user = User.from_omniauth(auth)
  #  if user.valid?
  #    session[:user_id] = user.id
  #    redirect_to user
  #  end
  #end
  
  def create
    if auth_hash
      identity = Identity.where(provider: auth_hash.provider, uid: auth_hash.uid).first
      if identity
        user = User.find_by(id: identity.user_id)
        identity.update_attributes!(
          token: auth_hash.credentials.token,
          secret: auth_hash.credentials.secret,
          expires_at: expires_at
        )
      else
        user = signed_in? ? current_user_session : User.create_user(name: auth_hash.info.name, email: auth_hash.info.email)
        Identity.create_identity(
          provider: auth_hash.provider,
          uid: auth_hash.uid,
          token: auth_hash.credentials.token,
          secret: auth_hash.credentials.secret,
          expires_at: expires_at,
          user_id: user.id
        )
      end
      session[:user_id] = user.id unless signed_in?
    end
    redirect_to current_user_session
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  def current_user_session
    return false if session[:user_id].nil?
    begin
      User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      session[:user_id] = nil
    end
  end

  def signed_in?
    !!current_user_session
  end
  
  private

  def auth_hash
    request.env["omniauth.auth"]
  end

  def expires_at
    if auth_hash.credentials.expires_at.present?
      Time.at(auth_hash.credentials.expires_at).to_datetime
    elsif auth_hash.credentials.expires_in.present?
      DateTime.now + auth_hash.credentials.expires_in.to_i.seconds
    end
  end
end
