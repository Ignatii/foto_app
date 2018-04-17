# require 'active_interaction'
# add functionality to show sorted images
module Images
  class Dislike < ActiveInteraction::Base
    integer :id
    object :user, class: '::User'

    validates :id, presence: true
    validates :user, presence: true
    validate  :check_exist_like

    def execute
      update_image
      image.reload
      update_leaderboard
      image
    end

    private

    def check_exist_like
      likes_count = image.likes.where(user_id: user.id).count
      return errors.add(:base, "Can't downvote for not voted image") if likes_count < 1
    end

    def image
      @image ||= Image.find_by(id: id)
    end

    def like
      @like ||= Like.find_by(user_id: user.id, image_id: image.id)
    end

    def update_image
      like_des = Like.find_by(user_id: user.id, image_id: image.id)
      return errors.merge!(Like.errors) unless Like.destroy(like_des.id)
    end

    def update_leaderboard
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.likes_count)
    rescue Redis::CannotConnectError
      'ok'
    end
  end
end
