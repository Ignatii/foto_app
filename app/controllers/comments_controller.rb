# comments controller for app
class CommentsController < ProxyController
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    result = Comments::Create.run(params.merge(user: current_user))
    message = result.errors.full_messages.to_sentence if result.invalid?
    flash = result.valid? ? { success: 'Comment added' } : { warning: message }
    red_img = Image.find_by(id: params[:comment][:image_id] || params[:comment][:comment_id])
    redirect_to red_img, flash: flash
  end

  def destroy
    destroy_comment = Comments::DestroyCustom.run(params['id'].merge(user: current_user))
    message = destroy_comment.errors.full_messages.to_sentence if result.invalid?
    flash = destroy_comment.valid? ? { success: 'Comment deleted' } : { warning: message }
    redirect_to request.referer, flash: flash
  end
end
