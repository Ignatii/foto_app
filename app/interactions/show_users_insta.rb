require 'active_interaction'
# add functionality to show needed images
class ShowUsersInsta < ActiveInteraction::Base
  object :user, class: '::User'

  validates :user, presence: true

  def execute
    # user = hash_user[:user]
    begin
      response = open("https://api.instagram.com/v1/users/self/media/recent/?access_token=#{user[:insta_token]}&count=12").read
      #res = open("https://api.instagram.com/v1/users/self/media/recent/?access_token=4088921481.a999fd0.64eec4699bd1882946ec2d8762e1&count=12").read
      response_parsed = JSON.parse response
      return @insta_images = response_parsed["data"]
    rescue OpenURI::HTTPError
      user.update_attributes(insta_token: nil)
      return errors.add(:base, 'Something went wrong with Instagramm or your key to it,please re-add it.')
    end
  end
end
