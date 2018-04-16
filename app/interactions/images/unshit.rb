require 'active_interaction'
# add functionality to show sorted images
module Images
  class Unshit < ActiveInteraction::Base
    integer :image_id # , class: '::Image'

    validates :image_id, presence: true

    def execute
      return errors.add(:base, 'Cant unshit image!') unless image.verify!
      update_leaderboard
    end

    private

    def image
      @image ||= Image.find(image_id)
    end

    def update_leaderboard
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
    rescue Redis::CannotConnectError
      'ok'
    end
  end
end
