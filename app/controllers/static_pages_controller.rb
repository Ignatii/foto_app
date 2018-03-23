# controller for static pages in app
class StaticPagesController < ProxyController
  skip_before_action :check_current_user
  skip_before_action :check_banned_user

  def home
    @images = ListImages.run!.page(params[:page]).per(12)
    @str = "https://www.facebook.com/dialog/feed?app_id=#{ENV['FB_ID']}&link=#{ENV['REDIRECT_INSTA']}&name=Foto gallery!&description=Cool Foto Gallery!&redirect_uri=#{ENV['REDIRECT_INSTA']}"
  end

  def help
  end

  def about
  end

  def contacts
  end
end
