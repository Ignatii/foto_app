# require 'active_interaction'
# add functionality to show needed images
module Images
  class List < ActiveInteraction::Base
    boolean :sort_data, default: nil
    boolean :sort_upvote, default: nil
    boolean :sort_comments, default: nil
    string :condition_search, default: nil

    def execute
      Redis.new.set('getstatus', 1)
      define_images
      sort_and_filter
    rescue Redis::CannotConnectError
      define_images(false)
      sort_and_filter
    end

    private

    def define_images(mode = true)
      @images = if mode
                  actualize_leaderboard
                  Image.find_ordered(ids)
                else
                  Image.verified_image.order(likes_count: :desc)
                end
    end

    def actualize_leaderboard
      create_leaderboard if IMAGE_VOTES_COUNT.leaders(IMAGE_VOTES_COUNT.total_pages).count.zero?
    end

    def create_leaderboard
      Image.all.verified_image.each do |image|
        IMAGE_VOTES_COUNT.rank_member(image.id.to_s, image.score_like)
      end
    end

    def sort_and_filter
      filter_images
      sort_images
    end

    def sort_images
      @images = sort_by_date if sort_data
      @images = sort_by_upvote if sort_upvote
      @images = sort_by_comments if sort_comments
      @images
    end

    def filter_images
      @images = search_by_title if condition_search.present?
      @images
    end

    def ids
      @ids = []
      IMAGE_VOTES_COUNT.leaders(IMAGE_VOTES_COUNT.total_pages).each do |img_rnk|
        @ids << img_rnk[:member].to_i
      end
      @ids
    end

    def search_by_title
      @images.where('title_img LIKE ? or tags LIKE ?',
                    "%#{condition_search}%",
                    "%#{condition_search}%")
    end

    def sort_by_date
      @images.reorder(created_at: :DESC)
    end

    def sort_by_upvote
      @images.reorder(likes_count: :ASC)
    end

    def sort_by_comments
      @images.reorder(commentable_count: :DESC)
    end
  end
end
