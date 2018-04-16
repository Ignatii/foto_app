class ImagesController < ProxyController
  # include RevealBannedUser
  skip_before_action :verify_authenticity_token
  skip_before_action :check_current_user, only: [:share]
  skip_before_action :check_banned_user, only: [:share]
  layout false, only: [:share]
  # layout 'application', :except => :share
  # layout :false, only: [:share]
  def show
    @image = Image.find(params[:id])
  end

  def create
    con = params[:image][:image].nil?
    return (flash[:warning] = 'Empty img!') && redirect_to(current_user) if con
    result = Images::Create.run(params: required_params.to_unsafe_h)
    res = result.valid?
    err_str = result.errors.full_messages.to_sentence unless res
    m = { flash: res ? { success: 'Image uploaded!Wait moderation' } : { warning: err_str } }
    redirect_to current_user, flash: m[:flash]
  end

  def share
    @shareimg = Image.find(params[:id])
    render layout: false
  end

  def create_remote
    return (flash[:warning] = 'Somethimg wrong! Talk with moderator') && redirect_to(current_user) unless params.key?(:url_image)
    result = Images::CreateRemote.run(params: params.to_unsafe_h)
    res = result.valid?
    flash[:warning] = result.errors.full_messages.to_sentence unless res
    flash[:success] = 'Image uploaded!Wait moderation :)' if res
    # case result.result
    # when true
    #   flash[:success] = 'Image uploaded from Instagram!Wait moderation :)'
    # else
    #   flash[:warning] = 'Image do not uploaded!'
    # end
    redirect_to current_user
  end

  # def destroy
  #   @image.destroy
  #   flash[:success] = 'Image deleted'
  #   redirect_to request.referer || root_url
  #   # redirect_back(fallback_location: root_url)
  # end

  def upvote_like
    result = Images::LikeInt.run image_id: params[:id], user: current_user
    res = result.valid?
    flash[:warning] = result.errors.full_messages.to_sentence unless res
    redirect_to root_url
  end

  def downvote_like
    result = Images::Dislike.run image_id: params[:id], user: current_user
    res = result.valid?
    flash[:warning] = result.errors.full_messages.to_sentence unless res
    redirect_to root_url
  end

  def unshit
    result = UnshitImage.run!
    flash[:success] = 'Image unshitted!' if result.valid?
    redirect_to request.referer
  end

  private

  def page(options)
    options[:page] || 1
  end

  def page_size(options)
    options[:page_size] || 12
  end

  def required_params
    params.require(:image).permit(:image,
                                  :title_img,
                                  :tags,
                                  :user_id)
  end
end
