# require 'active_interaction'
# add functionality to show needed images
module Comments
  class Create < ActiveInteraction::Base
    string :body
    integer :image_id
    integer :comment_id, default: 0
    object :user, class: '::User'

    validates :body, :image_id, :comment_id, presence: true
    validates :user, presence: true
    validate  :check_validate

    def execute
      @comment = parent.comments.create(body: body, user_id: user.id)
      return errors.merge!(@comment.errors) if @comment.invalid?
      @comment
    end

    private

    def parent
      zero_chk = comment_id.zero?
      return Image.find_by(id: image_id) if image_id && zero_chk
      return Comment.find_by(id: comment_id) unless zero_chk
    end

    def check_validate
      return errors.add(:base, 'Comment is empty!') if body.empty?
      return errors.add(:base, 'Not found parent') if parent.nil?
    end
  end
end
