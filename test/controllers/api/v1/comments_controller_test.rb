require 'test_helper'

class Api::V1::CommentsControllerTest < ActionController::TestCase
  test 'should not get info without token' do
    # request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    get :show, params: { id: Comment.first.id }
    assert_response 401
  end

  test 'show comment' do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    get :show, params: { id: Comment.first.id }
    assert_response 200
  end

  test 'show all comments on user' do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    get :index
    assert_response 200
  end

  test 'create comment on image' do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    post :create, params: { body: 'test_comment',
                            commentable_id: Image.first.id,
                            commentable_type: 'Image' }
    assert_response 200
  end

  test 'delete comment' do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    delete :destroy, params: { id_comment: Comment.first.id }
    assert_response 200
  end

  test 'not find to delete comment' do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    delete :destroy, params: { id_comment: 343_42 }
    assert_response 404
  end
end
