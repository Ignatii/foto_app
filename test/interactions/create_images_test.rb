require 'minitest/spec'
require 'minitest/autorun'
require 'test_helper'
# Image.transaction do
describe CreateImages do
  before do
    file = File.open('/home/ignatiy/Загрузки/ngrok-stable-linux-amd64.zip', 'r')
    @result_true = CreateImages.run(params: { image: file,
                                              title_img: 'testing title',
                                              tags: 'testing title1',
                                              user_id: User.first.id })
    @result_false = CreateImages.run(params: { image: file,
                                               title_img: 'testing title',
                                               tags: 'testing title1',
                                               user_id: User.first.id })
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
