# comments controller for app
class CommentsController < ProxyController
  skip_before_action :verify_authenticity_token
  # before_action :get_parent, only: [:create, :new]

  def new
    # @comment = @parent.comments.build
  end

  def create
    result = CreateComments.run(params: params.require(:comment).permit(:body, :image_id, :comment_id).to_unsafe_h,
                                user: current_user)
    res = result.valid?
    flash[:success] = result.result if res
    flash[:warning] = result.errors.full_messages.to_sentence unless res
    redirect_to Image.find_by(id: params[:comment][:image_id]) if params[:comment][:image_id] if Image.find_by(id: params[:comment][:image_id])
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    flash[:success] = 'Comment deleted'
    redirect_to request.referer
  end
end
