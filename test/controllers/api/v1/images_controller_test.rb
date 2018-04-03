require 'test_helper'

class Api::V1::ImagesControllerTest < ActionController::TestCase

  test "should not get info without token " do
    # request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    get :show, params: { id: Image.first.id }
    
    assert_response 401
  end

  test "should get info with token " do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    get :show, params: { id: Image.first.id }
    
    assert_response 200
  end

  test "should get all images per page" do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    get :index, params: { page: 1 }
    
    assert_response 200
  end

  test "should create image with token and file" do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    post :create, params: { image: fixture_file_upload('files/index.jpeg', 'image/jpeg') }
    
    assert_response 200
  end

  test "should like image with id and token" do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    put :upvote_like, params: { id: Image.second }
    
    assert_response 200
  end

  test "should not vote for alreay liked image with id and token" do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    put :upvote_like, params: { id: Image.first }
    
    assert_response 401
  end

  test "should dislike image with id and token" do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    put :downvote_like, params: { id: Image.first }
    
    assert_response 200
  end

  test "should not dislike not liked image with id and token" do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    put :downvote_like, params: { id: Image.second }
    
    assert_response 401
  end
end
