require 'active_interaction'
# add functionality to show sorted images
class UnshitImage < ActiveInteraction::Base
  integer :image_id # , class: '::Image'

  validates :image_id, presence: true

  def execute
    image.verify!
    update_leaderboard
  end

  private

  def image
    @image ||= Image.find(image_id)
  end

  def update_leaderboard
    begin
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
    rescue Redis::CannotConnectError
    end
  end
end
