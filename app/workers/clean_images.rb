# worker for sidekiq to delete rejected images
class CleanImages
  include Sidekiq::Worker

  def perform(id_image)
    image = Image.find_by(id: id_image)
    image.destroy! if image.rejected?
  end
end
