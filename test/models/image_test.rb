require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'should not save image without image' do
    image = Image.new
    user = users(:ignat)
    image.user_id = user.id
    assert_not image.save
  end

  test 'should return count of likes' do
    image = images(:one)
    assert_equal(1, image.score_like)
  end

  test 'should return count of comments' do
    image = images(:one)
    assert_equal(1, image.commentable_count)
  end

  test 'should verify from unverified image' do
    image = images(:one)
    image.verify!
    assert(image.verified?)
  end

  test 'should verify from rejected image' do
    image = images(:one)
    image.reject!
    image.verify!
    assert(image.verified?)
  end

  test 'should reject from unverified image' do
    image = images(:one)
    image.reject!
    assert(image.rejected?)
  end

  test 'should reject from verified image' do
    image = images(:one)
    image.verify!
    image.reject!
    assert(image.rejected?)
  end
end
