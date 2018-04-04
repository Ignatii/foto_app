require 'minitest/autorun'

User.transaction do 
describe FindImages do
  before do
  	@result_true = UpdateUsersInsta.run(user: User.first, token_insta: 'token=gfgsdfr4f')
    @result_false = UpdateUsersInsta.run(user: User.first, token_insta: 'gfgsdfr4f')
  end

  describe "when valid params passed" do
    it "must respond string" do
      @result_true.valid?.must_equal true
      @result_true.result.must_equal 'Your photos from instagram successfully added'
    end
  end

  describe "when invalid params passed" do
    it "must respond error" do
      @result_false.valid?.must_equal false
      @result_false.errors.full_messages.to_sentence.must_equal 'Problem with adding your instagram photos. Try later or contact admin'
    end
  end

end

raise ActiveRecord::Rollback
end