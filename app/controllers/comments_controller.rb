class CommentsController < ApplicationController  

  def create
    @image = Image.find(params[:image_id])
    @comment = @image.comments.create(:body => params[:comment][:body], :user => current_user)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to @image
    else
      flash.now[:danger] = "Can't create comment!"
    end
  end

  def update
    @comment = Comment.find(params[:comment_id])
    if @comment.update
     flash[:notice] = "You updated your comment"
    else
     flash[:alert] = "Failed to update"
    end
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment.destroy
    redirect_to @image.image_path
  end
end
