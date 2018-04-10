require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup { sign_in }

  test 'should show image with param' do
    assert get :show, params: { id: Image.first.id }
  end

  test 'should show share image with param' do
    assert get :share, params: { id: Image.first.id }
  end

  test 'should not save image without image' do
    user = User.first
    post :create, params: {}
    assert_equal('Choose image!', flash[:warning])
    assert_redirected_to "/user/#{user.id}"
  end

  test 'should not save image with params invalid' do
    user = User.first
    file = File.open('/home/ignatiy/Загрузки/index.jpeg', 'r')
    post :create,
         params: { image: { image: file,
                            title_img: 'testing',
                            tags: 'test tag',
                            user_id: user.id } }
    assert_equal('Image do not uploaded!', flash[:warning])
    assert_redirected_to "/user/#{user.id}"
  end

  test 'should save image with params image, title, tags and user_id' do
    user = User.first
    image = fixture_file_upload('files/index.jpeg', 'image/jpeg')
    post :create, params: { image: { image: image,
                                     title_img: 'testing',
                                     tags: 'test tag',
                                     user_id: user.id } }
    assert_equal('Image uploaded!Wait moderation :)', flash[:success])
    assert_redirected_to "/user/#{user.id}"
  end

  test 'should not save remote_image without url_image->url' do
    user = User.first
    # image = fixture_file_upload('files/index.jpeg', 'image/jpeg')
    get :create_remote, params: {}
    assert_equal('Somethimg wrong! Talk with moderator', flash[:warning])
    assert_redirected_to "/user/#{user.id}"
  end

  test 'should save remote_image with url_image->url text inta_tags user_id' do
    user = User.first
    # image = fixture_file_upload('files/index.jpeg', 'image/jpeg')
    get :create_remote, params: { url_image: { url: 'https://scontent.cdninstagram.com/vp/9225dda2a4739d20fe2a452b6c8491a1/5B6B6405/t51.2885-15/s320x320/e35/21689930_2017148641838602_4835430415567159296_n.jpg' },
                                  text: 'testing remote',
                                  inta_tags: 'test remote',
                                  user_id: user.id }
    assert_equal('Image uploaded from Instagram!Wait moderation :)',
                 flash[:success])
    assert_redirected_to "/user/#{user.id}"
  end

  test 'should not like if like exist and current user' do
    get :upvote_like, params: { id: Image.first }
    assert_not_nil(flash[:warning])
    assert_redirected_to root_url
  end

  test 'should like if id and current user' do
    get :upvote_like, params: { id: Image.second }
    assert_equal(nil, flash[:warning])
    assert_redirected_to root_url
  end

  test 'should dislike if id and current user' do
    get :downvote_like, params: { id: Image.first }
    assert_redirected_to root_url
  end
end
