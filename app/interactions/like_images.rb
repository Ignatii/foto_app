require 'active_interaction'
# add functionality to show sorted images
class LikeImages < ActiveInteraction::Base
  integer :image_id # , class: '::Image'
  object :user, class: '::User'

  validates :image_id, presence: true
  validates :user, presence: true

  def execute
    img_bln = image.likes.where(user_id: user[:id]).count.zero?
    return errors.add(:base, 'You already voted for this photo!') unless img_bln
    update_image
    update_leaderboard
    image.reload
  end

  private

  def image
    @image ||= Image.find(image_id)
  end

  def update_image
    img_lks_create = image.likes.create(user_id: user[:id])
    # img_upd = image.update(likes_img: image[:likes_img] + 1)
    return errors.merge!(Like.errors) unless img_lks_create
    # return errors.merge!(image.errors) unless img_upd
  end

  def update_leaderboard
    Redis.new.set('getstatus', 1)
    IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.likes_count)
  rescue Redis::CannotConnectError
    'ok'
  end
end
