# require 'active_interaction'
# add functionality to show needed images
module Comments
  class DestroyCustom < ActiveInteraction::Base
    integer :id
    object :user, class: '::User'

    validates :id_comment, presence: true
    validates :user, presence: true
    validate  :check_presence
    validate  :check_permission

    def execute
      return errors.merge!(comment.errors) unless comment.destroy
      true
    end

    private

    def comment
      @comment = Comment.find_by(id: id_comment)
    end

    def check_presence
      @comment = Comment.find_by(id: params['id_comment'])
      return errors.add(:base, 'Comment is empty!') if @comment.nil?
    end

    def check_permission
      return if comment.user_id == user.id
      errors.add(:base, 'You have no permission to delete this object')
    end
  end
end
