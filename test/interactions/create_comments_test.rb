require 'minitest/autorun'

Comment.transaction do
describe CreateComments do

  describe "create comment with parent-image and body" do
    it "must respond true" do
      @result_with_image = CreateComments.run(params: { body: 'test comment with parent-image',
                                           image_id: Image.first.id,
                                           comment_id: 0 },
                                           user: User.first)
      @result_with_image.result.must_equal true
      Comment.last.commentable_type.must_equal 'Image'
    end
  end

  describe "create comment with parent-comment and body" do
    it "must respond true and type" do
      #Comment.transaction do
      @result_with_comment = CreateComments.run(params: { body: 'test comment with parent-comment',
                                             image_id: Image.first.id,
                                             comment_id: Comment.first.id },
                                             user: User.first)
      @result_with_comment.result.must_equal true
      Comment.last.commentable_type.must_equal 'Comment'
      #raise ActiveRecord::Rollback
      #end
    end
  end
end

raise ActiveRecord::Rollback
end