require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  test 'should not save uniq info' do
    like = Like.new
    like.user_id = 1
    like.image_id = 1
    assert_not like.save
  end
end
