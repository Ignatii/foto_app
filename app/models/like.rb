# model for images in app
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :image
  validates :user_id, presence: true
  validates :image_id, presence: true
  validates :user_id, uniqueness: { scope: :image_id }
end
