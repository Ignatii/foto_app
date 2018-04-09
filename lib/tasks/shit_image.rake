namespace :shit_image do
  desc 'call intaraction for checking shitty images'
  task call_shitty: :environment do
    ShitImages.run!
  end
end
