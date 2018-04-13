require 'active_interaction'
# add functionality to show sorted images
class DislikeImages < ActiveInteraction::Base
  integer :image_id
  object :user, class: '::User'

  validates :image_id, presence: true
  validates :user, presence: true

  def execute
    lks_ct = image.likes.where(user_id: user.id).count
    return errors.add(:base, "Can't downvote for not voted image") if lks_ct < 1
    update_image
    update_leaderboard
    image
  end

  private

  def image
    @image ||= Image.find_by(id: image_id)
  end

  def like
    @like ||= Like.find_by(user_id: user.id, image_id: image.id)
  end

  def update_image
    like_des = Like.find_by(user_id: user.id, image_id: image.id)
    return errors.merge!(Like.errors) unless Like.destroy(like_des.id)
    #return errors.merge!(image.errors) unless image.update(likes_img: image[:likes_img] - 1) if image[:likes_img].positive?
  end

  def update_leaderboard
    begin
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
    rescue Redis::CannotConnectError
      # nothing to do here
    end
  end
end
