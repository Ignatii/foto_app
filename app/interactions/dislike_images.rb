require 'active_interaction'
# add functionality to show sorted images
class DislikeImages < ActiveInteraction::Base 
  integer :image_id
  object :user, class: '::User'

  validates :image_id, presence: true
  validates :user, presence: true

  def execute
    return false unless image.likes.where(user_id: user.id)
    update_image
    begin
      update_leaderboard
    ensure
      #update_image
      true
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
    Redis.new.set('getstatus', 1)
    IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
  end
end
