require 'active_interaction'
# add functionality to show needed images
class CreateSessions < ActiveInteraction::Base
  hash :auth_hash, strip: false
  object :session, class: 'ActionDispatch::Request::Session'

  validates :auth_hash, presence: true
  validates :session, presence: true

  def execute
    identity = Identity.where(provider: auth_hash[:provider],
                              uid: auth_hash[:uid]).first
    if identity
      user = User.find_by(id: identity.user_id)
      identity.update!(
        token: auth_hash[:credentials][:token],
        secret: auth_hash[:credentials][:secret],
        expires_at: expires_at
      )
    else
      email = auth_hash[:info][:email].nil? ? 'github' : auth_hash[:info][:email]
      user = signed_in? ? current_user_session : User.create_user(name: auth_hash[:info][:name], email: email)
      ident = Identity.new
      ident.create_identity(
        provider: auth_hash[:provider],
        uid: auth_hash[:uid],
        token: auth_hash[:credentials][:token],
        secret: auth_hash[:credentials][:secret],
        expires_at: expires_at,
        user_id: user.id
      )
    end
    session[:user_id] = user.id unless signed_in?
    user
  end

  def current_user_session
    return false if session[:user_id].nil?
    begin
      # user_path(User.find_by(id: session[:user_id]))
      User.find_by(id: session[:user_id])
    rescue ActiveRecord::RecordNotFound
      session[:user_id] = nil
      # root_path
    end
  end

  def signed_in?
    !!current_user_session
  end

  def expires_at
    if auth_hash[:credentials][:expires_at].present?
      Time.zone.at(auth_hash[:credentials][:expires_at]).to_datetime
    elsif auth_hash[:credentials][:expires_in].present?
      Time.zone.now + auth_hash[:credentials][:expires_in].to_i.seconds
    end
  end
end
