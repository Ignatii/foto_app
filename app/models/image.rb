class Image < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :comments, dependent: :destroy 
  validates :user_id, presence: true
  validates :image, presence: true
  #default_scope -> { order(created_at: :desc) }
  scope :recent_time, -> { where('created_at >= :1_day_ago', one_day_ago: Time.now - 1.day) }
  scope :recent, -> { recent_time.where("aasm_state = unverified") }
  mount_uploader :image, ImageUploader
  acts_as_votable
  
  aasm do
    state :unverified, initial: true
    state :rejected
    state :verified

    event :verify do
      transitions from: [:unverified], to: :verified
    end

    event :reject do
      transitions from: [:unverified], to: :rejected
    end

    event :reverify do
      transitions from: [:rejected], to: :verified
    end

    event :unverify do
      transitions from: [:verified], to: :rejected
    end
  end
end
