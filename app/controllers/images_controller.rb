class ImagesController < ProxyController
  # include RevealBannedUser
  skip_before_action :verify_authenticity_token
  skip_before_action :check_current_user, only: [:share]
  skip_before_action :check_banned_user, only: [:share]
  layout false, only: [:share]

  def show
    @image = Image.find(params[:id])
  end

  def create
    create_image = Images::Create.run(params: required_params.to_unsafe_h)
    err_str = create_image.errors.full_messages.to_sentence if create_image.invalid?
    flash = create_image.valid? ? { success: 'Image uploaded!Wait moderation' } : { warning: err_str }
    redirect_to current_user, flash: flash
  end

  def share
    @shareimg = Image.find(params[:id])
    render layout: false
  end

  def create_remote
    create_remote = Images::CreateRemote.run(params: params.to_unsafe_h)
    err_str = create_remote.errors.full_messages.to_sentence if create_remote.invalid?
    flash = create_remote.valid? ? { success: 'Image uploaded!Wait moderation' } : { warning: err_str }
    redirect_to current_user, flash: flash
  end

  def upvote_like
    upvote_image = Images::LikeInt.run(params.merge(user: current_user))
    flash[:warning] = upvote_image.errors.full_messages.to_sentence if upvote_image.invalid?
    redirect_to root_url
  end

  def downvote_like
    downvote_image = Images::Dislike.run(params.merge(user: current_user))
    flash[:warning] = result.errors.full_messages.to_sentence if downvote_image.invalid?
    redirect_to root_url
  end

  def unshit
    result = UnshitImage.run!
    flash[:success] = 'Image unshitted!' if result.valid?
    redirect_to request.referer
  end

  private

  def required_params
    params.require(:image).permit(:image,
                                  :title_img,
                                  :tags,
                                  :user_id)
  end
end
