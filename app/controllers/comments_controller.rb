class CommentsController < ApplicationController  

  before_action :get_parent, only: [:create, :new]
   
  def new
    @comment = @parent.comments.build
    image_id = params[:image_id_comment] if params[:image_id_comment]
    flash[:image_id] = params[:image_id_comment] if params[:image_id_comment]
    flash.keep(:image_id)
  end
 
  def create
    if !params[:comment][:body].empty?
	    @comment = @parent.comments.build(body: params[:comment][:body], user_id: current_user.id)
	    if @comment.save
	      flash[:success] = "Comment added"
	      redirect_to Image.find_by_id(params[:image_id]) if params[:image_id]
	      redirect_to Image.find_by_id(flash[:image_id]) if flash[:image_id]
	    else
 	      flash[:warning] = "Comment didn't save"
	      redirect_to Image.find_by_id(params[:image_id]) if params[:image_id]
	      redirect_to Image.find_by_id(flash[:image_id]) if flash[:image_id]
	    end
    else
      flash[:warning] = "Comment must not be empty!"
    end
  end

  def destroy
    @comment = Comment.find_by_id(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to request.referrer
  end
 
  protected
   
  def get_parent
    @parent = Image.find_by_id(params[:image_id]) if params[:image_id]
    @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
     
    redirect_to root_path unless defined?(@parent)
  end

  def image
    return @image if defined?(@image)
    @image = commentable.is_a?(Image) ? commentable : commentable.image
end
end
