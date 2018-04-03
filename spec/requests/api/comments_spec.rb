require 'rails_helper'

RSpec.describe 'CommentsAPI', type: :request do
  let!(:user) { create(:user, id: 1) }
  let!(:image) { create(:image, id: 1, user_id: user.id) }
  let!(:comment) { create(:comment, commentable_id: image.id, user_id: user.id) }
  
  describe 'GET /comments/:id' do
    it 'show comments on image' do
      get "/api/v1/comments/#{comment.id}", params: {}, headers: { 'HTTP_TOKEN_USER' => "#{user.api_token}" }
      # expect(response.body).to look_like_json
      result = JSON.parse response.body
      expect(response).to be_present
      expect(result['comment']).to be_present
      expect(response).to have_http_status(200)
    end

    it 'not show comments without token' do
      get "/api/v1/comments/#{image.id}", params: {}
      # expect(response.body).to look_like_json
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET /comments/' do
    it 'show all comments users' do
      comment = create(:comment,id: 2, commentable_id: image.id,user_id: user.id)
      get "/api/v1/comments/", params: {}, headers: { 'HTTP_TOKEN_USER' => "#{user.api_token}" }
      result = JSON.parse response.body
      expect(response).to be_present
      expect(result['comments']).to be_present
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /comments/' do
    it 'create comment' do
      post "/api/v1/comments/", params: { body: 'test',
                                        commentable_id: image.id,
                                        commentable_type: 'Image' },
                                headers: { 'HTTP_TOKEN_USER' => "#{user.api_token}" }
      result = JSON.parse response.body
      expect(response).to be_present
      expect(result['comment']).to be_present
      expect(response).to have_http_status(200)
    end

    it 'not create comment because of invalid params' do
      post "/api/v1/comments/", params: { commentable_id: image.id,
                                        commentable_type: 'Image' },
                                headers: { 'HTTP_TOKEN_USER' => "#{user.api_token}" }
      result = JSON.parse response.body
      expect(response).to be_present
      expect(result['error']).to eq( 'Cant save comment.Check all required parametres' )
      expect(response).to have_http_status(401)
    end
  end

  describe 'DELETE /comments/' do
    it 'delete comment' do
      delete "/api/v1/comments/", params: { id_comment: comment.id }, headers: { 'HTTP_TOKEN_USER' => "#{user.api_token}" }
      result = JSON.parse response.body
      expect(result['success']).to eq( 'Comment deleted' )
      expect(response).to have_http_status(200)
    end

    it 'not delete comment because cant find' do
      delete "/api/v1/comments/", params: { id_comment: 1245453 }, headers: { 'HTTP_TOKEN_USER' => "#{user.api_token}" }
      result = JSON.parse response.body
      expect(result['error']).to eq( 'Comment not found' )
      expect(response).to have_http_status(404)
    end
  end
end