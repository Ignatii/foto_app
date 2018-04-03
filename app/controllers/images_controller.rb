class ImagesController < ProxyController
  # include RevealBannedUser
  skip_before_action :verify_authenticity_token
  skip_before_action :check_current_user, only: [:share]
  skip_before_action :check_banned_user, only: [:share]
  layout false, only: [:share]
  #layout 'application', :except => :share
  #layout :false, only: [:share]
  def show
    @image = Image.find(params[:id])
  end

  def create
    return (flash[:warning] = 'Choose image!') && redirect_to(current_user) unless params.key?(:image)
    # (flash[:warning] = 'Choose image!') && redirect_to(current_user) && return unless params.key?(:image)
    result = CreateImages.run(params: params.require(:image).permit(:image, :title_img, :tags, :user_id).to_unsafe_h)
    case result.result
    when true
      flash[:success] = 'Image uploaded!Wait moderation :)'
    else
      flash[:warning] = 'Image do not uploaded!'
    end
    redirect_to current_user
  end

  def share
    @shareimg = Image.find(params[:id])
    render :layout => false
  end
  
  def create_remote
    return (flash[:warning] = 'Somethimg wrong! Talk with moderator') && redirect_to(current_user) unless params.key?(:url_image)
    result = CreateRemoteImages.run(params: params.to_unsafe_h)
    case result.result
    when true
      flash[:success] = 'Image uploaded from Instagram!Wait moderation :)'
    else
      flash[:warning] = 'Image do not uploaded!'
    end
    redirect_to current_user
  end

  # def destroy
  #   @image.destroy
  #   flash[:success] = 'Image deleted'
  #   redirect_to request.referer || root_url
  #   # redirect_back(fallback_location: root_url)
  # end

  def upvote_like
    result = LikeImages.run image_id: params[:id], user: current_user
    flash[:warning] = result.result unless result.valid?
    redirect_to root_url
  end

  def downvote_like
    result = DislikeImages.run image_id: params[:id], user: current_user
    flash[:warning] = result.result unless result.valid?
    redirect_to root_url
  end


  private

  def page(options)
    options[:page] || 1
  end

  def page_size(options)
    options[:page_size] || 12
  end
end
