require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:image) { create(:image) }
  
  before do
  	Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    get "/auth/facebook/callback"
  end

  describe 'GET home' do
    it 'show home page' do
      get root_url
      expect(response).to have_http_status(200)
    end

    it 'show home page with sort and filter' do
      get root_url, params: {xhr: true, condition_search: '', sort_data: 'true'}
      expect(response).to have_http_status(200)
    end
  end
end