OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :facebook, ENV['FB_ID'], ENV['FB_KEY']
  provider :instagram, ENV["INSTA_ID"], ENV["INSTA_KEY"], scope: 'basic'
  provider :vkontakte, ENV["VK_ID"], ENV["VK_KEY"], scope: 'basic'

  if Rails.env.test?
    provider :facebook, ENV['FB_ID'], ENV['FB_KEY']
  end
end



OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
  provider: 'facebook',
  uid: '123545',
  expires_at: "2018-03-29 13:10:12",
  info: {
        name: 'mockuser',
        email: 'mockemail@email.cpm'
  },
  credentials: {
        token: 'dfg433f4tg45twfrthrth',
        secret: nil
  }
})