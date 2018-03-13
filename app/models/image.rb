class Image < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  validates :user_id, presence: true
  validates :image, presence: true
  scope :recent_time, -> { where('created_at <= ?', Time.now - 1.day) } #'created_at >= ?', one_day_ago: Time.now - 1.day
  scope :recent, -> { recent_time.where(aasm_state: :rejected) }
  mount_uploader :image, ImageUploader
  acts_as_votable
  
  aasm do
    state :unverified, initial: true
    state :rejected
    state :verified

    event :verify do
      transitions from: [:unverified,:rejected], to: :verified
    end

    event :reject do
      transitions from: [:unverified,:verified], to: :rejected
    end
  end

  def score
    self.get_upvotes.size
  end
end
