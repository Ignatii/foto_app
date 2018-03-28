# controller for static pages in app
class StaticPagesController < ProxyController
  skip_before_action :check_current_user
  skip_before_action :check_banned_user
  respond_to :html, :js, :json, only: [:home]
  layout 'layouts/application', only: [:home]

  def home
    # sort_data = params['sort_data'] ? params['sort_data'] : false
    # sort_upvote = params['sort_upvote'] ? params['sort_upvote'] : false
    # sort_comments = params['sort_comments'] ? params['sort_comments'] : false
    @images = ListImages.run!.page(params[:page]).per(12)
    if request.xhr? == 0
      hash_params = {condition_search: params[:condition_search],
                    sort_data: params['sort_data'] ? true : false,
                    sort_upvote: params['sort_upvote'] ? true : false,
                    sort_comments: params['sort_comments'] ? true : false}
      @result = FindImages.run(params: hash_params)
      @images = @result.result
      debugger
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
