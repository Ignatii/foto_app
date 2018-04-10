require 'minitest/spec'
require 'minitest/autorun'
require 'test_helper'

# Image.transaction do
describe CreateRemoteImages do
  before do
    url_in = 'https://imagejournal.org/wp-content/uploads/bb-plugin/'\
             'cache/23466317216_b99485ba14_o-panorama.jpg'
    t = %w[testing insta teg]
    te = 'Testing text #ffff'
    id = User.first.id
    @result_true = CreateRemoteImages.run(params: { url_image: { url: url_in },
                                                    insta_tags: t,
                                                    text: te,
                                                    user_id: id })
    url_in = 'in/cache/23466317216_b99485ba14_o-panorama.jpg'
    t = %w[testing insta teg]
    te = 'Testing text #ffff'
    id = User.first.id
    @result_false = CreateRemoteImages.run(params: { url_image: { url: url_in },
                                                     insta_tags: t,
                                                     text: te,
                                                     user_id: id })
  end

  describe 'create image with valid params' do
    it 'must respond true' do
      @result_true.result.must_equal true
    end
  end

  describe 'create image with invalid params' do
    it 'must respond false' do
      @result_false.result.must_equal false
    end
  end
end

# raise ActiveRecord::Rollback
# end
