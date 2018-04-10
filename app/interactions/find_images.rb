require 'active_interaction'
# add functionality to show sorted images
class FindImages < ActiveInteraction::Base
  hash :params, strip: false

  validates :params, presence: true

  def execute
    images = ListImages.run!
    cond_str = params[:condition_search].empty?
    images = images.where('title_img LIKE ? or tags LIKE ?',
                          "%#{params[:condition_search]}%",
                          "%#{params[:condition_search]}%") unless cond_str
    images = images.reorder(created_at: :DESC) if params[:sort_data]
    images = images.reorder(likes_img: :ASC) if params[:sort_upvote] && !params[:sort_data]
    images = images.order(likes_img: :ASC) if params[:sort_upvote] && params[:sort_data]
    if params[:sort_comments]
      images.sort_by(&:comments_count).map do |image|
      end
    end
    # errors.add(:base, 'No photos in database!') if images.empty?
    images
  end
end
