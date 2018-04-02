require 'active_interaction'
# add functionality to show sorted images
class DislikeImages < ActiveInteraction::Base 
  integer :image_id
  object :user, class: '::User'

  validates :image_id, presence: true
  validates :user, presence: true

  def execute
    return false if image.likes.where(user_id: user.id).count < 1
    update_image
    begin
      update_leaderboard
    ensure
      #update_image
      return true
    end
  end

  private

  def image
    @image ||= Image.find_by(id: image_id)
  end

  def update_image
    Like.delete(Like.where(user_id: user.id,image_id: image.id))
    image.update_attributes(likes_img: image[:likes_img] - 1) if image[:likes_img] > 0
  end

  def update_leaderboard
    begin
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
    rescue Redis::CannotConnectError
    end 
  end
end
