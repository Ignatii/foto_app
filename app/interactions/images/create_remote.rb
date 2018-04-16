# require 'active_interaction'
# add functionality to show sorted images
module Images
  class CreateRemote < ActiveInteraction::Base
    hash :params, strip: false do
    end

    validates :params, presence: true

    def execute
      @image = user.images.create(remote_image_url: params[:url_image][:url],
                                  tags: tags,
                                  title_img: title)
      return errors.merge!(@image.errors) unless @image
      @image
    end

    private

    def user
      @user ||= User.find_by(id: params[:user_id])
    end

    def tags
      @tags = params[:insta_tags].join(' ') unless params[:insta_tags].nil?
    end

    def title
      @title_img = params[:text].split('#')[0] unless params[:text].nil?
    end
  end
end
