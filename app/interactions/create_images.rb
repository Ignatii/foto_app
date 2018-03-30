require 'active_interaction'
# add functionality to show sorted images
class CreateImages < ActiveInteraction::Base
  hash :params do 
    file :image
    string :title_img
    string :tags
    integer :user_id
  end

  validates :params, presence: true

  def execute
    save_image
  end

  private

  def user
    @user ||= User.find_by(id: params[:user_id])
  end

  def save_image
    image = user.images.build(image: params[:image])
    image.title_img = params[:title]
    image.tags = params[:tags]
    if image.save
      true
    else
      false
    end
  end
end
