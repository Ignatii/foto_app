require 'rails_helper'

RSpec.describe 'ImagesAPI', type: :request do
  let(:user) { create(:user) }
  let(:image) { create(:image, user_id: user.id) }
  describe 'GET /images/:id' do
    it 'show images info' do
      str_ap = user.api_token.to_s
      get "/api/v1/images/#{image.id}",
          params: {},
          headers: { 'HTTP_TOKEN_USER' => str_ap }
      # expect(response.body).to look_like_json
      result = JSON.parse response.body
      expect(response).to be_present
      expect(result['image']).to be_present
      expect(response).to have_http_status(200)
    end

    it 'doesnt show images info without token' do
      get "/api/v1/images/#{image.id}", params: {}
      # expect(response.body).to look_like_json
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET /images/' do
    it 'show all images info per page' do
      get "/api/v1/images/#{image.id}",
          params: { page: 1 },
          headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      expect(response).to have_http_status(200)
      expect(response).to be_present
    end
  end

  describe 'post /images/' do
    it 'create image' do
      post '/api/v1/images',
           params: { image: fixture_file_upload('files/index.jpeg',
                                                'image/jpeg') },
           headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      expect(response).to be_present
      expect(response).to have_http_status(200)
    end

    it 'not create image because of file' do
      post '/api/v1/images',
           params: {},
           headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      result = JSON.parse response.body
      expect(result['error']).to eq('Pass image!')
      expect(response).to have_http_status(401)
    end

    it 'not create image because of invalid data' do
      post '/api/v1/images',
           params: { image: 'dfdfdfdf' },
           headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      result = JSON.parse response.body
      expect(result['error']).to eq('Image not uploaded')
      expect(response).to have_http_status(401)
    end
  end

  describe 'PUT /images/like' do
    it 'create like to image' do
      put '/api/v1/images/like',
          params: { id: image.id },
          headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      result = JSON.parse response.body
      expect(result['image']).to be_present
      expect(response).to have_http_status(200)
    end

    it 'not create like to already liked image' do
      create(:like, user_id: 1, image_id: image.id)
      put '/api/v1/images/like',
          params: { id: image.id },
          headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      result = JSON.parse response.body
      message = 'Current user already upvoted for this picture'
      expect(result['error']).to eq(message)
      expect(response).to have_http_status(401)
    end
  end

  describe 'PUT /images/dislike' do
    it 'create dislike to image' do
      create(:like, user_id: 1, image_id: image.id)
      put '/api/v1/images/dislike',
          params: { id: image.id },
          headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      result = JSON.parse response.body
      expect(result['image']).to be_present
      expect(response).to have_http_status(200)
    end

    it 'not dislike to not liked image' do
      @image = create(:image, id: 3, user_id: user.id)
      put '/api/v1/images/dislike',
          params: { id: 3 },
          headers: { 'HTTP_TOKEN_USER' => user.api_token.to_s }
      result = JSON.parse response.body
      expect(result['error']).to eq('Current user didnt voted for this picture')
      expect(response).to have_http_status(401)
    end
  end
end
