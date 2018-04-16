require 'rails_helper'

RSpec.describe 'Users', type: :request do
  # let(:user) { create(:user) }
  # let(:identity) { create(:identity) }

  before do
    omni ||= OmniAuth.config.mock_auth[:facebook]
    Rails.application.env_config['omniauth.auth'] = omni
    get '/auth/facebook/callback'
  end

  # it 'should set user_id if logged in' do
  #     expect(session[:user_id]).to eq(User.last.id)
  # end

  describe 'GET /user/:id' do
    it 'returns users page' do
      get "/user/#{session[:user_id]}"
      expect(response).to render_template(:show)
    end
  end

  describe 'PUT /user/:id' do
    it 'update user insta if token added' do
      put "/user/#{session[:user_id]}", params: { 'token_insta' => 'token=gff' }
      expect(flash[:success]).to be_present
      expect(response).to redirect_to("/user/#{session[:user_id]}")
    end

    it 'not update user insta if invalid token added' do
      put "/user/#{session[:user_id]}", params: { 'token_insta' => 'gfgrtfdf' }
      expect(flash[:warning]).to be_present
      expect(response).to redirect_to("/user/#{session[:user_id]}")
    end
  end
end
