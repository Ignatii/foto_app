require 'minitest/autorun'

# Image.transaction do
describe Images::LikeInt do
  before do
    like = Like.where(image_id: Image.second.id).first
    Like.where(image_id: Image.second.id).first.delete if like
    @result_true = Images::LikeInt.run(image_id: Image.second.id, user: User.first)
    @result_false = Images::LikeInt.run(image_id: Image.first.id, user: User.first)
  end

  describe 'when liked by user who didnt like' do
    it 'must respond true' do
      @result_true.valid?.must_equal true
    end
  end

  describe 'when liked by user who already liked' do
    it 'must respond false' do
      @result_false.valid?.must_equal false
    end
  end
end

# raise ActiveRecord::Rollback
# end
