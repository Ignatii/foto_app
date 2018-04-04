require 'minitest/autorun'

Image.transaction do 
describe LikeImages do
  before do
  	Like.where(image_id: Image.second.id).first.delete if Like.where(image_id: Image.second.id).first
    @result_true = LikeImages.run(image_id:Image.second.id, user: User.first)
    @result_false = LikeImages.run(image_id:Image.first.id, user: User.first)
  end

  describe "when liked by user who didnt like" do
    it "must respond true" do
      @result_true.valid?.must_equal true
    end
  end

  describe "when liked by user who already liked" do
    it "must respond false" do
      @result_false.valid?.must_equal false
    end
  end
end

raise ActiveRecord::Rollback
end