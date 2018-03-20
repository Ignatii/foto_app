# uploader for images
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
    process resize_to_fill: [200, 200]
  end

  version :thumb_lg do
    process resize_to_fill: [450, 500]
  end

  # Restrict uploads to images only
  def extension_white_list
    %w[jpg jpeg gif png]
  end
end
