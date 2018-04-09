require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test 'should do signup' do
    OmniAuth.config.test_mode = true
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    get :create, params: { provider: 'facebook' }
    assert_redirected_to "/user/#{session[:user_id]}"
  end
end
