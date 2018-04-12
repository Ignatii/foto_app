require 'active_interaction'
# add functionality to show needed images
class ShowUsersInsta < ActiveInteraction::Base
  object :user, class: '::User'

  validates :user, presence: true

  def execute
    ActiveSupport::Notifications.instrument('ShowUsersInsta.running',
                                            desc: 'Shows insta photos') do
      begin
        response = open('https://api.instagram.com/v1/users/'\
        "self/media/recent/?access_token=#{user[:insta_token]}&count=12").read
        response_parsed = JSON.parse response
        return @insta_images = response_parsed['data']
      rescue OpenURI::HTTPError
        user.update(insta_token: nil)
        mes = 'Something wrong with Insta or your key to it,please re-add it.'
        return errors.add(:base, mes)
      end
    end
  end
end
