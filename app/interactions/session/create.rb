# require 'active_interaction'
# add functionality to show needed images
module Session
  class Create < ActiveInteraction::Base
    hash :auth_hash, strip: false
    object :session, class: 'ActionDispatch::Request::Session'

    validates :auth_hash, presence: true
    validates :session, presence: true

    def execute
      if identity
        user = User.find_by(id: identity.user_id)
        update_identity
      else
        user = signed_in? ? current_user_session : User.create_user(name: auth_hash[:info][:name], email: mail)
        create_identity
      end
      session[:user_id] = user.id unless signed_in?
      user
    end

    private

    def mail
      @mail = auth_hash[:info][:email].nil? ? 'github' : auth_hash[:info][:email]
    end

    def identity
      @identity ||= Identity.create_with(token: auth_hash[:credentials][:token],
                                         secret: auth_hash[:credentials][:secret],
                                         expires_at: expires_at,
                                         user_id: user.id)
                            .find_or_create_by(provider: auth_hash[:provider],
                                               uid: auth_hash[:uid])
    end

    def create_identity
      Identity.create(
        provider: auth_hash[:provider],
        uid: auth_hash[:uid],
        token: auth_hash[:credentials][:token],
        secret: auth_hash[:credentials][:secret],
        expires_at: expires_at,
        user_id: user.id
      )
    end

    def update_identity
      identity.update!(
        token: auth_hash[:credentials][:token],
        secret: auth_hash[:credentials][:secret],
        expires_at: expires_at
      )
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

    def expires_at
      if auth_hash[:credentials][:expires_at].present?
        (auth_hash[:credentials][:expires_at]).to_datetime
      elsif auth_hash[:credentials][:expires_in].present?
        Time.current + auth_hash[:credentials][:expires_in].to_i.seconds
      end
    end
  end
end
