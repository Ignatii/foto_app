require 'active_interaction'
# add functionality to show needed images
class CreateComments < ActiveInteraction::Base
  hash :params do
    string :body
    integer :image_id
    integer :comment_id, default: 0
  end
  object :user, class: '::User'

  validates :params, presence: true
  validates :user, presence: true
  def execute
    return errors.add(:base, 'Comment is empty!') if params[:body].empty?
    @comment = parent.comments.build(body: params[:body], user_id: user.id)
    return errors.merge!(@comment.errors) unless @comment
    # if @comment.save
    #   true
    # else
    #   false
    # end
    return errors.merge!(@comment.errors) unless @comment.save
    return @comment if @comment.save
  end

  def parent
    zero_chk = params[:comment_id].zero?
    return Image.find_by(id: params[:image_id]) if params[:image_id] && zero_chk
    return Comment.find_by(id: params[:comment_id]) unless zero_chk
  end
end
