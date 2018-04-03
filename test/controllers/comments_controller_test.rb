require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup { sign_in }

  test "should redirect to image if no body comment" do
  	#controller.stub(current_user: User.first)
  	# session[:user_id] = user.id
  	image = Image.first
  	user = User.first
    # comment = image.comments.build(body: 'test')
    #get image_url(image), params: { image_id: image.id }

    #post :create, params: {image_id: image.id, comment: {body: 'test'} }
    post :create, params: {image_id: image.id, comment: {body: ''} }
    assert_equal( 'Comment must not be empty!', flash[:warning])
    assert_redirected_to "/images/#{image.id}"
  end

  test "should redirect to image if comment save with parent image and comment_id =0" do
    image = Image.first
    user = User.first
    post :create, params: {image_id: image.id, comment: {body: 'test',
                                                        image_id: image.id,
                                                        comment_id: 0} }
    assert_equal( 'Comment added', flash[:success])
    assert_redirected_to "/images/#{image.id}"
  end

  test "should redirect to image if comment save with parent comment" do
    image = Image.first
    user = User.first
    comment = Comment.first
    post :create, params: {image_id: image.id, comment: {body: 'test',
                                                        image_id: image.id,
                                                        comment_id: comment.id} }
    assert_equal( 'Comment added', flash[:success])
    assert_redirected_to "/images/#{image.id}"
  end

  test "should redirect to image if comment didnt saves" do
    image = Image.first
    user = User.first
    post :create, params: {image_id: image.id, comment: {body: 'test',image_id: image.id} }
    #debugger
    assert_equal( 'Comment didnt save', flash[:warning])
    assert_redirected_to "/images/#{image.id}"
  end

  test "should delete comment" do
  	#controller.stub(current_user: User.first)
  	# session[:user_id] = user.id
    # comment = image.comments.build(body: 'test')
    #get image_url(image), params: { image_id: image.id }
    id_image = Comment.first.commentable_id
    #referer = image_path(Image.find_by(id: id_image))
    request.env['HTTP_REFERER'] = image_path(Image.find_by(id: id_image))
    delete :destroy, params: { id: Comment.first.id }
    assert_redirected_to "/images/#{id_image}"
  end
  
end
