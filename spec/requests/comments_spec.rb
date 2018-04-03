require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:image) { create(:image) }
  let(:comment) { create(:comment) }
  #let(:identity) { create(:identity) }
  
  before do
  	Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    get "/auth/facebook/callback"
  end

  describe 'POST /comments/' do
    it 'returns to images page if comment body is empty' do
      post "/comments/", params: {image_id: image.id, comment: {body: ''} }
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to match(/Comment must not be empty!*/)
      expect(response).to redirect_to("/images/#{image.id}")
    end

    it 'returns to images page and save comment with parent image' do
      post "/comments/", params: {image_id: image.id, comment: { body: 'test',
                                                        image_id: image.id,
                                                        comment_id: 0} }
      expect(flash[:success]).to be_present
      expect(flash[:success]).to match(/Comment added*/)
      expect(response).to redirect_to("/images/#{image.id}")
    end

    it 'returns to images page and save comment with parent comment' do
      post "/comments/", params: {image_id: image.id, comment: { body: 'test',
                                                        image_id: image.id,
                                                        comment_id: comment.id} }
      expect(flash[:success]).to be_present
      expect(flash[:success]).to match(/Comment added*/)
      expect(response).to redirect_to("/images/#{image.id}")
    end

    it 'returns to images page but didnt save comment because of invalid data' do
      post "/comments/", params: {image_id: image.id, comment: { body: 'test',
                                                        image_id: image.id} }
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to match(/Comment didnt save*/)
      expect(response).to redirect_to("/images/#{image.id}")
    end
  end

  describe 'DELETE /comments/' do
    it 'returns to images page after deleting comment' do
      create(:image, id: 4)
      create(:comment,id: 2, commentable_id: image.id)
      id_image = comment.commentable_id
      #controller.request.env['HTTP_REFERER'] = image_path(image)
      #controller.request.should_receive(:referer).and_return("http://example.com/#{image_path(image)}")
      delete "/comments/#{comment.id}", params: {}, headers: { 'HTTP_REFERER' => "#{image_path(image)}" }
      expect(response).to redirect_to("/images/#{id_image}")
    end
  end
end