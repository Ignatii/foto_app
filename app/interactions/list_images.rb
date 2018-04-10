require 'active_interaction'
# add functionality to show needed images
class ListImages < ActiveInteraction::Base
  def execute
    begin
      Redis.new.set('getstatus', 1)
      if IMAGE_VOTES_COUNT.leaders(IMAGE_VOTES_COUNT.total_pages).count.zero?
        Image.all.verified_image.each do |image|
          # IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score)
          IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
        end
      end
      @ids ||= []
      IMAGE_VOTES_COUNT.leaders(IMAGE_VOTES_COUNT.total_pages).each do |img_rnk|
        @ids << img_rnk[:member].to_i
      end
      @images = Image.find_ordered(@ids)
      # errors.add(:base, 'No photos in database!')
      @images
    rescue Redis::CannotConnectError
      Image.verified_image.order(likes_img: :desc)
    end
  end
end
