# comments controller for app
class CommentsController < ProxyController
  skip_before_action :verify_authenticity_token
  before_action :get_parent, only: [:create, :new]

  def new
    @comment = @parent.comments.build
  end

  def create
    if !params[:comment][:body].empty?
      @comment = @parent.comments.build(body: params[:comment][:body], user_id: current_user.id)
      if @comment.save
        flash[:success] = 'Comment added'
      else
        flash[:warning] = 'Comment didnt save'
      end
      redirect_to Image.find_by(id: params[:image_id]) if params[:image_id]
      redirect_to Image.find_by(id: params[:comment][:image_id]) if params[:comment][:image_id]
    else
      flash[:warning] = 'Comment must not be empty!'
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    flash[:success] = 'Comment deleted'
    redirect_to request.referer
  end

  protected

  def get_parent
    @parent = Image.find_by(id: params[:image_id]) if params[:image_id]
    @parent = Comment.find_by(id: params[:comment_id]) if params[:comment_id]

    redirect_to root_path unless defined?(@parent)
  end

  def image
    return @image if defined?(@image)
    @image = commentable.is_a?(Image) ? commentable : commentable.image
  end
end
