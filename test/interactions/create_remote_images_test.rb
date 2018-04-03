require 'minitest/spec'
require 'minitest/autorun'
require 'test_helper'

Image.transaction do
describe CreateRemoteImages do
  before do
    # image = fixture_file_upload('files/index.jpeg', 'image/jpeg')
  	@result_true = CreateRemoteImages.run(params: { url_image: {
                                          url: 'https://imagejournal.org/wp-content/uploads/bb-plugin/cache/23466317216_b99485ba14_o-panorama.jpg'} ,
                                          insta_tags: ['testing', 'insta', 'teg'],
                                          text: 'Testing text #ffff',
                                          user_id: User.first.id })
    @result_false = CreateRemoteImages.run(params: { url_image: {
                                          url: 'in/cache/23466317216_b99485ba14_o-panorama.jpg'} ,
                                          insta_tags: ['testing', 'insta', 'teg'],
                                          text: 'Testing text #ffff',
                                          user_id: User.first.id })
  end

  describe "create image with valid params" do
    it "must respond true" do
      @result_true.result.must_equal true
    end
  end

  describe "create image with invalid params" do
    it "must respond false" do
      @result_false.result.must_equal false
    end
  end
end

raise ActiveRecord::Rollback
end