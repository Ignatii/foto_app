# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_to_fill => [200, 200]
  end

  version :thumb_lg do
    process :resize_to_fill => [450, 500]
  end

  #version :with_mirror do
  #  process :resize_to_fill => [200, 200]
  #  process :add_mirror_effect => 0.2
  #end

  # Restrict uploads to images only
  def extension_white_list
    %w(jpg jpeg gif png)
  end

#private

 # def add_mirror_effect(mirror_length)
  #  manipulate! do |img|
   #   mirror_rows = img.rows * mirror_length

#      gradient = Magick::GradientFill.new(0, 0, mirror_rows, 0, "#888", "#000")
 #     gradient = Magick::Image.new(img.columns, mirror_rows, gradient)
  #    gradient.matte = false

   #   flipped = img.flip
    #  flipped.matte = true
     # flipped.composite!(gradient, 0, 0, Magick::CopyOpacityCompositeOp)

  #    new_frame = Magick::Image.new(img.columns, img.rows + mirror_rows)
   #   new_frame.composite!(img, 0, 0, Magick::OverCompositeOp)
    #  new_frame.composite!(flipped, 0, img.rows, Magick::OverCompositeOp)
   # end
#end

end
