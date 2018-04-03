require 'minitest/autorun'

User.transaction do 
describe FindImages do
  before do
  	@result_true = UpdateUsersInsta.run(user: User.first, token_insta: 'token=gfgsdfr4f')
    @result_false = UpdateUsersInsta.run(user: User.first, token_insta: 'gfgsdfr4f')
  end

  describe "when valid params passed" do
    it "must respond true" do
      @result_true.result.must_equal true
    end
  end

  describe "when invalid params passed" do
    it "must respond false" do
      @result_false.result.must_equal false
    end
  end

end

raise ActiveRecord::Rollback
end