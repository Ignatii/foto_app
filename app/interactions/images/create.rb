# require 'active_interaction'
# add functionality to show sorted images
module Images
  class Create < ActiveInteraction::Base
    hash :params do
      file :image
      string :title_img
      string :tags
      integer :user_id
    end

    validates :params, presence: true

    def execute
      image = user.images.create(image: params[:image],
                                 title_img: params[:title],
                                 tags: params[:tags])
      return errors.merge!(image.errors) unless image
      image
    end

    private

    def user
      @user ||= User.find_by(id: params[:user_id])
    end
  end
end
