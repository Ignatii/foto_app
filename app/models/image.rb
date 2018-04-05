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
  
  # ransacker :search_name, formatter: ->(search) {
  # #ids = Image.allUser.all.where(name: search).map(&:id)
  #   ids = Image.joins(:user).where('LOWER(users.name) LIKE ?', "%#{search.downcase}%").ids if ENV['RAILS_ENV'] == 'production'
  #   ids = Image.joins(:user).where(name.match("%#{search}%")).ids if ENV['RAILS_ENV'] == 'development'
  #   ids = ids.any? ? ids : nil
  # } do |parent|  #   parent.table[:id]
  # end
  Image.ransacker :search_comment, formatter: ->(search) {
    debugger
    ids = Comment.distinct.select(:commentable_id).where("commentable_type == 'Image' and body like '%#{search}%'").pluck(:commentable_id)
    ids = ids.any? ? ids : nil
  } do |parent|
    parent.table[:id]
  end
  # ransacker :search_comment, formatter: ->(search) {
  # #ids = Image.allUser.all.where(name: search).map(&:id)
  #   # ids = Image.joins(:comment).where('LOWER(comments.body) LIKE ?', "%#{search.downcase}%").ids if ENV['RAILS_ENV'] == 'production'
  #   # ids = Image.joins(:comment).where(body.match("%#{search}%")).ids if ENV['RAILS_ENV'] == 'development'
  #   #results = ActiveRecord::Base.connection.execute("SELECT commentable_id FROM comments WHERE commentable_type == 'Image' and body like '(%"+ search +"%)' GROUP BY commentable_id")

  #   #ids = Image.comments.where('comments.body LIKE "%test%"').ids
  #   ids = Comment.distinct.select(:commentable_id).where("commentable_type == 'Image' and body like '%#{search}%'").pluck(:commentable_id)
  #   ids = ids.any? ? ids : nil
  # } do |parent|
  #   parent.table[:id]
  # end

  def score_like
    self.likes.count
  end
  
  def comments_count
    comments.count
  end
end
