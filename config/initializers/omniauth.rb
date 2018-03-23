OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :facebook, ENV['FB_ID'], ENV['FB_KEY']
  provider :instagram, ENV["INSTA_ID"], ENV["INSTA_KEY"], scope: 'basic'
  provider :vkontakte, ENV["VK_ID"], ENV["VK_KEY"], scope: 'basic'
end
