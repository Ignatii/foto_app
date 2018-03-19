class StaticPagesController < ProxyController
<<<<<<< HEAD
  skip_before_action :check_current_user
  skip_before_action :check_banned_user

  def home
    @images = ListImages.run!.page(params[:page]).per(12)   
  end

  def help
  end

  def about
  end

  def contacts
  end
end
