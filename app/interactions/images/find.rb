# require 'active_interaction'
# add functionality to show sorted images
module Images
  class Find < ActiveInteraction::Base
    hash :params, strip: false

    validates :params, presence: true

    def execute
      cond_str = params[:condition_search].empty?
      images = images.where('title_img LIKE ? or tags LIKE ?',
                            "%#{params[:condition_search]}%",
                            "%#{params[:condition_search]}%") unless cond_str
      images = images.reorder(created_at: :DESC) if params[:sort_data]
      images = images.reorder(likes_count: :ASC) if params[:sort_upvote] && !params[:sort_data]
      images = images.order(likes_count: :ASC) if params[:sort_upvote] && params[:sort_data]
      images = images.reorder(commentable_count: :DESC) if params[:sort_comments]
      #   images.sort_by(&:commentable_count).map do |image|
      #   end
      # end
      # errors.add(:base, 'No photos in database!') if images.empty?
      images
    end

    private

    # def ololo

    # end

    def images
      @images ||= Images::List.run!
    end
  end
end
