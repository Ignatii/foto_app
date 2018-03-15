require 'active_interaction'

class UpvoteImage < ActiveInteraction::Base
  integer :id_image
  integer :id_user

  validates :id_image, presence: true, if: :id_image?
  validates :id_user, presence: true, if: :id_user?

  def execute
    @image = Image.find_by(id: id_image)
    @user = User.find_by(id: id_user)
    if !@user.voted_down_on?(@image)
      begin
        r = Redis.new.set('getstatus',1)
        @image.upvote_by @user
        IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score)             	
      rescue Redis::CannotConnectError
        @image.upvote_by @user
      end
      return "Your vote accepted"
    else
      return "You already voted for this picture"
    end
  end
end
