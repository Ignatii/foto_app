require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not save user without name and email" do
    user = User.new
    assert_not user.save
  end

  test "should not save user without api_token" do
    user = User.new
    user.name = 'test'
    user.email = 'test@test.com'
    assert_not user.save
  end
end
