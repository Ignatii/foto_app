class CommentsController < ApplicationController  

  before_action :get_parent
   
  def new
    @comment = @parent.comments.build
  end
 
  def create
    @comment = @parent.comments.build(body: params[:comment][:body], user_id: current_user.id)
     debugger
    if @comment.save
      redirect_to root_url, :notice => 'Thank you for your comment!'
    else
      render :new
    end
  end
 
  protected
   
  def get_parent
    @parent = Image.find_by_id(params[:image_id]) if params[:image_id]
    @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
     
    redirect_to root_path unless defined?(@parent)
  end

  def image
    return @image if defined?(@image)
    @image = commentable.is_a?(Image) ? commentable : commentable.post
end
end
