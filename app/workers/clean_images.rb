class CleanImages
  include Sidekiq::Worker
  #include Sidetiq::Schedulable

 # recurrence { daily }

  def perform
    File.delete(Image.recent[:image]) if File.exist?(Image.recent[:image])
    Image.recent.destroy_all
  end
end
