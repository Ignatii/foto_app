class StaticPagesController < ApplicationController
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
