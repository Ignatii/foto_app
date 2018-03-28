require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test "should not save image without image" do
  	user = User.first
    # image = Image.new
    assert_not user.image.build()
  end
end
