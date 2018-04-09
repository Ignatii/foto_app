require 'minitest/autorun'

# Image.transaction do
describe DislikeImages do
  before do
    Like.create(user_id: User.first.id, image_id: Image.first.id)
    Like.where(image_id: Image.second.id).first.delete if Like.where(image_id: Image.second.id).first
    @result_false = DislikeImages.run(image_id: Image.second.id,
                                      user: User.first)
    @result_true = DislikeImages.run(image_id: Image.first.id, user: User.first)
  end

  describe 'dislike if liked by user' do
    it 'must respond true' do
      @result_true.valid?.must_equal true
    end
  end

  describe 'dont dislike if user didnt liked it' do
    it 'must respond false' do
      @result_false.valid?.must_equal false
    end
  end
end

# raise ActiveRecord::Rollback
# end
