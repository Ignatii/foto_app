require 'active_interaction'
# add functionality to show needed images
module Admin
  class ImageVerify < ActiveInteraction::Base
    integer :image_id
    validates :image_id, presence: true
    def execute
      check_state
      return errors.add(:base, 'Error verifying!') unless image.verify!
      update_leaderboard
      image
    end

    private

    def image
      @image ||= Image.find(image_id)
    end

    def update_leaderboard
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(image_id.to_s, image.likes_img)
    rescue Redis::CannotConnectError
      errors.add(:base, 'Redis not working!')
    end

    def check_state
      return unless image.rejected?
      scheduled = Sidekiq::ScheduledSet.new.select
      scheduled.map do |job|
        job.delete if job.args == Array(image_id.to_i)
      end.compact
    end
  end
end
