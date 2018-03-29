require 'active_interaction'
# add functionality to show sorted images
class CreateImages < ActiveInteraction::Base
  hash :params_img do 
    file :img
    object :user, class: '::User'
    string :title
    string :tags
  end

  validates :params_img, presence: true

  def execute
    @image = params_img[:user].images.build(image: params_img[:img])
    @image.title_img = params_img[:title_img]
    @image.tags = params_img[:tags]
    if @image.save
      true
    else
      false
    end
  end
end
