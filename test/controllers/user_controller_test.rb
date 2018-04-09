require 'test_helper'

class UserControllerTest < ActionController::TestCase
  setup { sign_in }

  test 'should not update user without token_insta' do
    user = User.first
    put :update, params: { id: User.first.id, 'token_insta' => '' }
    assert_redirected_to "/user/#{user.id}"
  end

  test 'should not update user with invalid token_insta' do
    user = User.first
    put :update, params: { id: User.first.id, 'token_insta' => '1111' }
    me = 'Problem with adding your instagram photos. Try later or contact admin'
    assert_equal(me, flash[:warning])
    assert_redirected_to "/user/#{user.id}"
  end

  test 'should update user with valid token_insta' do
    user = User.first
    put :update, params: { id: User.first.id,
                           'token_insta' => 'token=fgfgfgfgfg' }
    message = 'Your photos from instagram successfully added'
    assert_equal(message, flash[:success])
    assert_redirected_to "/user/#{user.id}"
  end

  test 'should not find user without id only current user' do
    # user = User.first
    get :show, params: { id: 3 }
    assert_response(:success)
  end

  test 'should find user and insta_photos' do
    # user = User.first
    get :show, params: { id: 3 }
    assert_response(:success)
  end
end
