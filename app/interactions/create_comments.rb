require 'active_interaction'
# add functionality to show needed images
class CreateComments < ActiveInteraction::Base
  hash :params do 
    string :body
    integer :image_id
    integer :comment_id
  end 
  object :user, class: '::User'

  validates :params, presence: true
  validates :user, presence: true
  def execute
    @comment = parent.comments.build(body: params[:body], user_id: user.id)
    if @comment.save
      true
    else
      false
    end
  end

  def parent
    return Image.find_by(id: params[:image_id]) if params[:image_id] && params[:comment_id].zero?
    return Comment.find_by(id: params[:comment_id]) unless params[:comment_id].zero?
  end
end
