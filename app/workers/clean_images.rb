class CleanImages
  include Sidekiq::Worker

  def perform(id_image)
    image = Image.find_by(id: id_image)
    if image.rejected?
      image.destroy!
    end
  end
end
