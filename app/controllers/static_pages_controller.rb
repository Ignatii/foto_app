# controller for static pages in app
class StaticPagesController < ProxyController
  skip_before_action :check_current_user
  skip_before_action :check_banned_user
  respond_to :html, :js, :json, only: [:home]
  layout 'layouts/application', only: [:home]

  def home
    @images = ListImages.run!.page(params[:page]).per(12)
    return @images unless request.xhr?
    @result = FindImages.run(params: params.permit(:condition_search,
                                                   :sort_data,
                                                   :sort_upvote,
                                                   :sort_comments).to_unsafe_h)
    @images = @result.result
    respond_to do |format|
      format.js {}
    end
    # end
  end

  def help
  end

  def about
  end

  def contacts
  end
end
