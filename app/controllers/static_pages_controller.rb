# controller for static pages in app
class StaticPagesController < ProxyController
  skip_before_action :check_current_user
  skip_before_action :check_banned_user
  respond_to :html, :js, :json, only: [:home]
  layout 'layouts/application', only: [:home]

  def home
    @images = ListImages.run!.page(params[:page]).per(12)
    if params[:condition_search]
      @images_all = ListImages.run!.page(params[:page]).per(12)
      @images = @images_all.where("title_img LIKE ? or tags LIKE ?" , "%#{params[:condition_search]}%","%#{params[:condition_search]}%").page(params[:page]).per(12)
    end
    @str = "https://www.facebook.com/dialog/feed?app_id=#{ENV['FB_ID']}&link=#{ENV['REDIRECT_INSTA']}&name=Foto gallery!&description=Cool Foto Gallery!&redirect_uri=#{ENV['REDIRECT_INSTA']}"
    if params['sort_data'] == 'true' || params['sort_upvote'] == 'true' || params['sort_upvote'] == 'sort_comments'
      # @images = @images.where(id: '18').page(params[:page]).per(12) if params['sort'] == 'sort_data'
      @images = @images.reorder(created_at: :DESC) if params['sort_data'] == 'true'
      if params['sort_data'] == 'false'
        @images = @images.reorder(cached_votes_up: :DESC) if params['sort_upvote'] == 'true'
      elsif params['sort_data'] == 'true'
        @images = @images.order(cached_votes_up: :DESC) if params['sort_upvote'] == 'true'
      end
      if params['sort_comments'] == 'true'
        @images.sort_by(&:comments_count).map do |image|
        end
      end
      respond_to do |format|
        format.html { render @images }
        #format.html
        #format.html { respond_with @images }
      end
    end
  end

  def help
  end

  def about
  end

  def contacts
  end
end
