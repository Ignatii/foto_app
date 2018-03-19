class User < ApplicationRecord
  before_create :generate_authentication_token
  has_many :images, dependent: :destroy
  has_many :comments, dependent: :destroy 
  acts_as_voter

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      if auth.provider == "facebook"
	      user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      else
	      user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.oauth_token = auth.credentials.token
      end
      
      user.save!
    end
  end

  def generate_authentication_token
      loop do
        self.api_token = SecureRandom.base64(20)
        break unless User.find_by(api_token: api_token)
      end
  end
end
