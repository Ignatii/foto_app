require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  end

  it 'sign up user' do
    get '/auth/facebook/callback'
    expect(response).to redirect_to("/user/#{session[:user_id]}")
  end
end
