# require 'active_interaction'
# add functionality to show needed images
module Images
  class List < ActiveInteraction::Base
    hash :params, strip: false

    validates :params, presence: true
    def execute
      Redis.new.set('getstatus', 1)
      work_with_redis
    rescue Redis::CannotConnectError
      work_without_redis
    end

    private

    def work_without_redis
      images = Image.verified_image.order(likes_count: :desc)
      images = title_search(images) if params[:condition_search] && params[:condition_search].present?
      images = sort_in_date(images) if params[:sort_data]
      images = sort_in_upvote(images) if params[:sort_upvote]
      images = sort_in_comments(images) if params[:sort_comments]
      images
    end

    def work_with_redis
      actualize_leaderboard if IMAGE_VOTES_COUNT.leaders(IMAGE_VOTES_COUNT.total_pages).count.zero?
      images = Image.find_ordered(ids)
      images = title_search(images) if params[:condition_search] && params[:condition_search].present?
      images = sort_in_date(images) if params[:sort_data]
      images = sort_in_upvote(images) if params[:sort_upvote]
      images = sort_in_comments(images) if params[:sort_comments]
      images
    end

    def actualize_leaderboard
      Image.all.verified_image.each do |image|
        IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
      end
    end

    def ids
      @ids = []
      IMAGE_VOTES_COUNT.leaders(IMAGE_VOTES_COUNT.total_pages).each do |img_rnk|
        @ids << img_rnk[:member].to_i
      end
      @ids
    end

    def title_search(images)
      images.where('title_img LIKE ? or tags LIKE ?',
                   "%#{params[:condition_search]}%",
                   "%#{params[:condition_search]}%")
    end

    def sort_in_date(images)
      images.reorder(created_at: :DESC)
    end

    def sort_in_upvote(images)
      images.reorder(created_at: :DESC)
    end

    def sort_in_comments(images)
      images.reorder(commentable_count: :DESC)
    end
  end
end
