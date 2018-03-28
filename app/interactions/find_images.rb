require 'active_interaction'
# add functionality to show sorted images
class FindImages < ActiveInteraction::Base
  hash :params do
    string :condition_search
    boolean :sort_data
    boolean :sort_upvote
    boolean :sort_comments
  end

  validates :params, presence: true

  def execute
    images = ListImages.run!
    images = images.where("title_img LIKE ? or tags LIKE ?" , "%#{params[:condition_search]}%","%#{params[:condition_search]}%") unless params[:condition_search].empty?
    images = images.reorder(created_at: :DESC) if params[:sort_data]
    images = images.reorder(cached_votes_up: :DESC) if params[:sort_upvote] && !params[:sort_data]
    images = images.order(cached_votes_up: :DESC) if params[:sort_upvote] && params[:sort_data]
    if params[:sort_comments]
      images.sort_by(&:comments_count).map do |image|
      end
    end
    images
  end
end
