require 'active_interaction'
# add functionality to show sorted images
class LikeImages < ActiveInteraction::Base
  integer :image_id # , class: '::Image'
  object :user, class: '::User'

  validates :image_id, presence: true
  validates :user, presence: true

  def execute
    return false unless image.likes.where(user_id: user[:id]).count == 0
    update_image
    begin
      update_leaderboard
    ensure
      return true
    end
  end

  private

  def image
    @image ||= Image.find(image_id)
  end

  def update_image
    image.likes.create(user_id: user[:id])
    image.update_attributes(likes_img: image[:likes_img] + 1)
  end

  def update_leaderboard
    begin
      Redis.new.set('getstatus', 1)   
      IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
    rescue Redis::CannotConnectError
    end  
  end
end
