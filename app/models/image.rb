# model for images in app
class Image < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates :user_id, presence: true
  validates :image, presence: true
  scope :verified_image, -> { where(aasm_state: :verified) }
  mount_uploader :image, ImageUploader
  # acts_as_votable

  aasm do
    state :unverified, initial: true
    state :rejected
    state :verified

    event :verify do
      transitions from: [:unverified, :rejected], to: :verified
    end

    event :reject do
      transitions from: [:unverified, :verified], to: :rejected
    end
  end

  def score
    get_upvotes.size
  end

  def score_like
    self.likes.count
  end
  
  def comments_count
    comments.count
  end
end
