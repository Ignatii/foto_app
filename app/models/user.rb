# model for users in app
class User < ApplicationRecord
  before_commit :generate_authentication_token, only: [:create_user]
  has_many :images, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :identities, dependent: :destroy
  acts_as_voter

  def self.create_user(info)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #  user.provider = auth.provider
    #  user.uid = auth.uid
    #  user.name = auth.info.name
    #  user.email = auth.info.email
    #  user.oauth_token = auth.credentials.token
    #  user.oauth_expires_at = Time.zone.at(auth.credentials.expires_at) if auth.provider == 'facebook'
    #  user.save!
    # end
    create(name: info[:name], email: info[:email])
  end

  def generate_authentication_token
    loop do
      self.api_token = SecureRandom.base64(20)
      break unless User.find_by(api_token: api_token)
    end
  end
end
