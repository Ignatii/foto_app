# controller for static pages in app
class StaticPagesController < ProxyController
  skip_before_action :check_current_user
  skip_before_action :check_banned_user
  respond_to :html, :js, :json, only: [:home]
  layout 'layouts/application', only: [:home]

  def home
    # @images.page(params[:page]).per(12)
    respond_to do |format|
      format.js do
        @images = Images::List.run(params: required_params.to_unsafe_h).result
      end
      format.html { @images = Images::List.run(params: { a: '' }).result.page(params[:page]).per(12) }
    end
    # end
  end

  def help
  end

  def about
  end

  def contacts
  end

  private

  def required_params
    params.permit(:condition_search,
                  :sort_data,
                  :sort_upvote,
                  :sort_comments)
  end
end
