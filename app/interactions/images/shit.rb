require 'active_interaction'
# add functionality to show needed images
module Images
  class Shit < ActiveInteraction::Base
    def execute
      images = Image.cron_image
      images.each do |image|
        image.shit! unless image.shited?
        UserMailer.send_email(image.user).deliver! if image.user.email.include? '@'
        Redis.new.set('getstatus', 1)
        IMAGE_VOTES_COUNT.remove_member(image.id)
      end
    rescue Redis::CannotConnectError
      'ok'
    end
  end
end
