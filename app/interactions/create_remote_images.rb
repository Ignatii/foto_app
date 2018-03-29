require 'active_interaction'
# add functionality to show sorted images
class CreateRemoteImages < ActiveInteraction::Base
  hash :params_img do 
    string :img_url
    object :user, class: '::User'
    string :title
    array :tags
  end

  validates :params_img, presence: true

  def execute
    debugger
    @images = params_img[:user].images.build(remote_image_url: params_img[:img_url])
    @images.tags = params_img[:tags].join(' ') unless params_img[:tags].nil?
    @images.title_img = params_img[:title].split('#')[0] unless params_img[:title].nil?
    if @images.save
      true
    else
      false
    end
  end
end
