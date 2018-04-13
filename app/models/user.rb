# model for users in app
class User < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :countries, through: :visits
  validates :name, presence: true
  validates :email, presence: true
  accepts_nested_attributes_for :visits, allow_destroy: true
  before_create :generate_authentication_token

  def create_user(info)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #  user.provider = auth.provider
    #  user.uid = auth.uid
    #  user.name = auth.info.name
    #  user.email = auth.info.email
    #  user.oauth_token = auth.credentials.token
    #  user.oauth_expires_at = Time.zone.at(auth.credentials.expires_at)
    # if auth.provider == 'facebook'
    #  user.save!
    # end
    User.create(name: info[:name], email: info[:email])
  end

  def generate_authentication_token
    loop do
      self.api_token = SecureRandom.base64(20)
      break unless User.find_by(api_token: api_token)
    end
  end
end
