# comments controller for app
class CommentsController < ProxyController
  skip_before_action :verify_authenticity_token
  # before_action :get_parent, only: [:create, :new]

  def new
    # @comment = @parent.comments.build
  end

  def create
    result = Comments::Create.run(params: required_params.to_unsafe_h, user: current_user)
    res = result.valid?
    err = result.errors.full_messages.to_sentence
    m = { flash: res ? { success: 'Comment added' } : { warning: err } }
    red_img = Image.find_by(id: params[:comment][:image_id])
    red_img_c = Image.find_by(id: params[:comment][:image_id])
    redirect_path = red_img ? red_img : red_img_c
    redirect_to redirect_path, flash: m[:flash]
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    m = { flash: @comment.nil? ? { warning: 'Comment not found!' } : { success: 'Comment deleted' } }
    redirect_to request.referer, flash: m[:flash] if @comment.nil?
    @comment.destroy
    redirect_to request.referer, flash: m[:flash]
  end

  private

  def required_params
    params.require(:comment).permit(:body, :image_id, :comment_id)
  end
end
