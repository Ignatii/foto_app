# require 'active_interaction'
# add functionality to show needed images
module Images
  class ShowUsersInsta < ActiveInteraction::Base
    object :user, class: '::User'

    validates :user, presence: true

    def execute
      @insta_images = response_parsed['data']
    rescue OpenURI::HTTPError
      rescue_connect
    end

    private

    def response_parsed
      errors.add(:base, 'SOmething with your key to insta') if user.insta_token.empty?
      response = open('https://api.instagram.com/v1/users/'\
      "self/media/recent/?access_token=#{user[:insta_token]}&count=12").read
      @response_parsed = JSON.parse response
    end

    def rescue_connect
      user.update(insta_token: nil)
      errors.add(:base, 'Something wrong with Insta or your key to it,please re-add it.')
    end
  end
end
