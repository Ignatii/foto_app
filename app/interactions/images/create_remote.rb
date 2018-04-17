# require 'active_interaction'
# add functionality to show sorted images
module Images
  class CreateRemote < ActiveInteraction::Base
    hash :params, strip: false do
    end

    validates :params, presence: true
    validate :check_url_existence

    def execute
      @image = user.images.create(remote_image_url: params[:url_image][:url],
                                  tags: tags,
                                  title_img: title)
      return errors.merge!(@image.errors) unless @image
      @image
    end

    private

    def check_url_existence
      return errors.add(:base, 'Somethimg wrong! Talk with moderator') if params[:url_image].empty?
    end

    def user
      @user ||= User.find_by(id: params[:user_id])
    end

    def tags
      params[:insta_tags].join(' ') if params[:insta_tags].present?
    end

    def title
      @title_img = params[:text].split('#')[0] unless params[:text].nil?
    end
  end
end
