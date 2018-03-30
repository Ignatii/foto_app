# comments controller for app
class CommentsController < ProxyController
  skip_before_action :verify_authenticity_token
  #before_action :get_parent, only: [:create, :new]

  def new
    #@comment = @parent.comments.build
  end

  def create
    return (flash[:warning] = 'Comment must not be empty!') && redirect_to(image_path(Image.find_by(id: params[:image_id]))) if params[:comment][:body].empty?
    result = CreateComments.run(params: params.require(:comment).permit(:body,:image_id, :comment_id).to_unsafe_h,
                                user: current_user)
    flash[:success] = 'Comment added' if result.result
    flash[:warning] = 'Comment didnt save' unless result.result
    #redirect_to image_path(Image.find_by(id: params[:image_id])) if params[:image_id]
    redirect_to Image.find_by(id: params[:comment][:image_id]) if params[:comment][:image_id]
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    flash[:success] = 'Comment deleted'
    redirect_to request.referer
  end
end
