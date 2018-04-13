require 'active_interaction'
# add functionality to show needed images
class AdminImageReject < ActiveInteraction::Base
  integer :image_id
  validates :image_id, presence: true
  def execute
    return errors.add(:base, 'Error rejecting!') unless image.reject!
    CleanImages.perform_at(1.hour.from_now, image.id)
    update_leaderboard
  end

  private

  def image
    @image ||= Image.find(image_id)
  end

  def update_leaderboard
    begin
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.remove_member(params[:id])
    rescue Redis::CannotConnectError
      return errors.add(:base, 'Redis not working!')
    end
  end
end
