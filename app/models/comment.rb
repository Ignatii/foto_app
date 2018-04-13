# model comments for comments in app
class Comment < ApplicationRecord
  validates :user_id, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  belongs_to :commentable, polymorphic: true, counter_cache: :commentable_count
  has_many :comments,
           as: :commentable, dependent: :destroy
end
