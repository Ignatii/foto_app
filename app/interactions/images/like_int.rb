# require 'active_interaction'
# add functionality to show sorted images
module Images
  class LikeInt < ActiveInteraction::Base
    integer :id # , class: '::Image'
    object :user, class: '::User'

    validates :id, presence: true
    validates :user, presence: true
    validate :check_like

    def execute
      update_image
      update_leaderboard
      image.reload
    end

    private

    def check_like
      image_voted = image.likes.where(user_id: user[:id]).count.zero?
      return errors.add(:base, 'You already voted for this image!') unless image_voted
    end

    def image
      @image ||= Image.find(id)
    end

    def update_image
      img_lks_create = image.likes.create(user_id: user[:id])
      return errors.merge!(Like.errors) unless img_lks_create
    end

    def update_leaderboard
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.likes_count)
    rescue Redis::CannotConnectError
      'ok'
    end
  end
end
