# model for images in app
class Image < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates :user_id, presence: true
  validates :image, presence: true
  scope :verified_image, -> { where(aasm_state: :verified) }
  scope :cron_image, -> { where('updated_at < ? AND likes_img < ? AND aasm_state == "verified"', 2.days.ago, 1) }
  mount_uploader :image, ImageUploader
  # acts_as_votable

  aasm do
    state :unverified, initial: true
    state :rejected
    state :verified
    state :shited

    event :verify do
      transitions from: %i[unverified rejected shited], to: :verified
    end

    event :reject do
      transitions from: %i[unverified verified], to: :rejected
    end

    event :shit do
      transitions from: [:verified], to: :shited
    end
  end

  # Image.ransacker :search_comment, formatter: ->(search) {
  #   debugger
  #   ids = Comment.distinct.select(:commentable_id).where(
  #   "commentable_type == 'Image' and body like '%#{search}%'")
  #   .pluck(:commentable_id)
  #   ids = ids.any? ? ids : nil
  # } do |parent|
  #   parent.table[:id]
  # end

  def score_like
    likes.count
  end

  def self.comments_count
    comments.count
  end
end
