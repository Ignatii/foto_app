# comments controller for app
class CommentsController < ProxyController
  skip_before_action :verify_authenticity_token
  # before_action :get_parent, only: [:create, :new]

  def new
    # @comment = @parent.comments.build
  end

  def create
    par_f_com = params.require(:comment).permit(:body, :image_id, :comment_id)
    par_f_com = par_f_com.to_unsafe_h
    result = CreateComments.run(params: par_f_com, user: current_user)
    res = result.valid?
    flash[:success] = result.result if res
    flash[:warning] = result.errors.full_messages.to_sentence unless res
    red_img = Image.find_by(id: params[:comment][:image_id])
    red_img_c = Image.find_by(id: params[:comment][:image_id])
    redirect_path = red_img if red_img
    redirect_path = red_img_c if red_img_c
    redirect_to redirect_path
    # redirect_to red_img_c if red_img_c
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    flash[:success] = 'Comment deleted'
    redirect_to request.referer
  end
end
