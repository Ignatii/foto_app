require 'rails_helper'

RSpec.describe 'UsersAPI', type: :request do
  let(:user) { create(:user) }

  describe 'GET /users/:id' do
    it 'show users info' do
      get '/api/v1/users/',
          params: {},
          headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      expect(response).to have_http_status(200)
    end

    it 'doesnt show users info without token' do
      get '/api/v1/users/', params: {}
      expect(response).to have_http_status(401)
    end
  end
end
