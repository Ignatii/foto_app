require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  test 'should get show with users token' do
    request.headers['HTTP_TOKEN_USER'] = User.first.api_token
    get :index
    assert_response :success
    assert_response 200
    assert response.body
    # JSON.parse response.body
    # assert_equal Mime::JSON, response.content_type
  end

  test 'should not get show withouy users token' do
    get :index
    assert_response 401
    # assert response.body
    # JSON.parse response.body
    # assert_equal Mime::JSON, response.content_type
  end
end
