require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  test "should show image with param" do
    #get :show, params: {id: Image.first.id}
    assert get :show, params: {id: Image.first.id}
  end

  test "should not save image without image" do
    
  end
end
