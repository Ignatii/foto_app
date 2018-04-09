require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test 'should response 200' do
    get :home
    assert_response(:success)
  end

  test 'should response when sorting and filtering' do
    get :home, params: { xhr: true, condition_search: '', sort_data: 'true' }
    assert_response(:success)
  end
end
