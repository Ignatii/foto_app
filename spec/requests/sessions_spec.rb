require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  before do
    omni ||= OmniAuth.config.mock_auth[:facebook]
    Rails.application.env_config['omniauth.auth'] = omni
  end

  it 'sign up user' do
    get '/auth/facebook/callback'
    expect(response).to redirect_to("/user/#{session[:user_id]}")
  end
end
