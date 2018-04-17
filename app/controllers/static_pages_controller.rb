# controller for static pages in app
class StaticPagesController < ProxyController
  skip_before_action :check_current_user
  skip_before_action :check_banned_user
  respond_to :html, :js, :json, only: [:home]

  def home
    respond_to do |format|
      format.js do
        @images = Images::List.run(params).result
      end
      format.html do
        @images = Images::List.run(params).result.page(params[:page]).per(12)
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
