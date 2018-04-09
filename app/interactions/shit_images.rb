require 'active_interaction'
# add functionality to show needed images
class ShitImages < ActiveInteraction::Base
  def execute
    images = Image.cron_image
    images.each do |image|
      image.shit! unless image.shited?
      if image.user.email.include? '@'
        UserMailer.send_email(image.user).deliver!
      end
      begin
        Redis.new.set('getstatus', 1)
        IMAGE_VOTES_COUNT.remove_member(image.id)
      rescue Redis::CannotConnectError
      end
    end
  end
end
