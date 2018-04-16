require 'test_helper'

# Comment.transaction do
describe Comments::Create do
  describe 'create comment with parent-image and body' do
    it 'must respond true' do
      @result_with_image = Comments::Create.run(params: { body: 'test',
                                                          image_id: id,
                                                          comment_id: 0 },
                                                user: User.first)
      @result_with_image.result.must_equal 'Comment added'
      Comment.last.commentable_type.must_equal 'Image'
    end
  end

  describe 'create comment with parent-comment and body' do
    it 'must respond true and type' do
      # Comment.transaction do
      id = Image.first.id
      id_com = Comment.first.id
      @result_with_comment = Comments::Create.run(params: { body: 'test comment',
                                                            image_id: id,
                                                            comment_id: id_com },
                                                  user: User.first)
      @result_with_comment.result.must_equal 'Comment added'
      Comment.last.commentable_type.must_equal 'Comment'
      # raise ActiveRecord::Rollback
      # end
    end
  end
end

# raise ActiveRecord::Rollback
# end
