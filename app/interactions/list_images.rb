require 'active_interaction'

class ListImages < ActiveInteraction::Base
  def execute
    begin
      r = Redis.new.set('getstatus',1)
      if IMAGE_VOTES_COUNT.leaders(IMAGE_VOTES_COUNT.total_pages).count == 0
        Images.all.verified_image.each do |image|
	  IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score)
    	end
      end
      @ids ||= []
      IMAGE_VOTES_COUNT.leaders(IMAGE_VOTES_COUNT.total_pages).each do |image_rank|
	@ids<< image_rank[:member].to_i
	#@images += Image.find_by(id:image_rank[:member].to_i)
	
      end
      @images = Image.find_ordered(@ids)
      return @images              	
    rescue Redis::CannotConnectError
      return Image.verified_image.order(:cached_votes_up)
    end
  end
end
