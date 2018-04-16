# require 'active_interaction'
# add functionality to show needed images
module Comments
  class Create < ActiveInteraction::Base
    hash :params do
      string :body
      integer :image_id
      integer :comment_id, default: 0
    end
    object :user, class: '::User'

    validates :params, presence: true
    validates :user, presence: true
    validate  :check_validate

    def execute
      @comment = parent.comments.create(body: params[:body], user_id: user.id)
      return errors.merge!(@comment.errors) unless @comment
      @comment
    end

    private

    def parent
      zero_chk = params[:comment_id].zero?
      return Image.find_by(id: params[:image_id]) if params[:image_id] && zero_chk
      return Comment.find_by(id: params[:comment_id]) unless zero_chk
    end

    def check_validate
      return errors.add(:base, 'Comment is empty!') if params[:body].empty?
      return errors.add(:base, 'Not found parent') if parent.nil?
    end
  end
end
