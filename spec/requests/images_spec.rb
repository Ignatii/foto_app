require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:image) { create(:image) }

  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    get '/auth/facebook/callback'
  end

  describe 'GET /images/:id' do
    it 'show image with id' do
      get "/images/#{image.id}"
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /image/share' do
    it 'show share image with id' do
      get "/images/share/#{image.id}"
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /images' do
    it 'shouldnt save without image' do
      post '/images'
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to match(/Choose image!*/)
      expect(response).to redirect_to("/user/#{session[:user_id]}")
    end

    it 'should not save image with params invalid(image), title, tags' do
      post '/images', params: { image: { image: 'dfdfdfdfdf',
                                         title_img: 'testing',
                                         tags: 'test tag',
                                         user_id: session[:user_id] } }
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to match(/Image do not uploaded!*/)
      expect(response).to redirect_to("/user/#{session[:user_id]}")
    end

    it 'should save image with params valid(image), title, tags and user_id' do
      post '/images', params: {image: { image: File.open('/home/ignatiy/Загрузки/index.jpeg','r'),
                                        title_img: 'testing',
                                        tags: 'test tag',
                                        user_id: session[:user_id] } }
      expect(flash[:success]).to be_present
      # expect(flash[:success]).to match(/Image uploaded!Wait moderation*/)
      expect(response).to redirect_to("/user/#{session[:user_id]}")
    end
  end

  describe 'GET /images' do
    it 'shouldnt save remote without valid params image' do
      get '/users/create_remote/', params: {}
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to match(/Somethimg wrong! Talk with moderator*/)
      expect(response).to redirect_to("/user/#{session[:user_id]}")
    end

    it 'should save remote with valid params image' do
      get '/users/create_remote/', params: { url_image: { url: 'https://scontent.cdninstagram.com/vp/9225dda2a4739d20fe2a452b6c8491a1/5B6B6405/t51.2885-15/s320x320/e35/21689930_2017148641838602_4835430415567159296_n.jpg' },
                                             text: 'testing remote',
                                             inta_tags: 'test remote',
                                             user_id: session[:user_id] }
      expect(flash[:success]).to be_present
      expect(response).to redirect_to("/user/#{session[:user_id]}")
    end
  end

  describe 'PUT /images/like' do
    it 'should like existent image' do
      put "/images/#{image.id}/like"
      expect(flash[:warning]).to be_nil
      expect(response).to redirect_to(root_url)
    end

    it 'shouldnt like already voted image' do
      @image = create(:image, id: 4)
      @like = create(:like, image_id: 4)
      put "/images/#{@image.id}/like"
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to match(/You already voted for this photo!*/)
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'PUT /images/dislike' do
    it 'should dislike already liked image' do
      @image = create(:image, id: 4)
      create(:like, image_id: 4)
      put "/images/#{@image.id}/dislike"
      expect(flash[:warning]).to be_nil
      expect(response).to redirect_to(root_url)
    end
  end
end
