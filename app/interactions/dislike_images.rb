require 'active_interaction'
# add functionality to show sorted images
class LikeImages < ActiveInteraction::Base
  hash :params_img do 
    object :image, class: '::Image'
    object :user, class: '::User'
  end

  validates :params_img, presence: true

  def execute
    @image = params_img[:image]
    current_user = params_img[:user]
    if @image.likes.where(user_id: current_user.id).count == 0
      begin
        Redis.new.set('getstatus', 1)
        #@image.upvote_by current_user
        @image.update_attributes(likes_img: @image[:likes_img] + 1)
        @image.likes.create(user_id: current_user.id)        
        IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score_like)
      rescue Redis::CannotConnectError
        @image.likes.create(user_id: current_user.id)
        @image.update_attributes(likes_img: @image[:likes_img] + 1)
      end
      return true
    else
      false
    end
  end
end
