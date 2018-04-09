require 'active_interaction'
# add functionality to show sorted images
class CreateRemoteImages < ActiveInteraction::Base
  hash :params, strip: false do
  end

  validates :params, presence: true

  def execute
    save_image
  end

  def user
    @user ||= User.find_by(id: params[:user_id])
  end

  def save_image
    @images = user.images.build(remote_image_url: params[:url_image][:url])
    @images.tags = params[:insta_tags].join(' ') unless params[:insta_tags].nil?
    @images.title_img = params[:text].split('#')[0] unless params[:text].nil?
    return errors.merge!(@images.errors) unless @images.save
    @images
  end
end
