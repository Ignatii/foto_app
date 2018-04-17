# require 'active_interaction'
# add functionality to show sorted images
module Images
  class Create < ActiveInteraction::Base
    file :image
    string :title_img
    string :tags
    object :user, class: '::User'

    validates :image, :title_img, :tags, :user, presence: true
    validate :check_image

    def execute
      image_create = user.images.create(image: image,
                                        title_img: title_img,
                                        tags: tags)
      return errors.merge!(image.errors) unless image_create.valid?
      image_create
    end

    private

    def check_image
      return errors.add(:base, 'Empty image!') if image.empty?
    end
  end
end
