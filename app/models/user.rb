class User < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :comments, dependent: :destroy 
  acts_as_voter

 def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      if auth.provider == "facebook"
	user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      else
	user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.oauth_token = auth.credentials.token
      end
      
      user.save!
    end
  end
end
