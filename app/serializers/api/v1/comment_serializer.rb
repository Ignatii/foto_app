# serializer for comments in API
module Api
  module V1
    class CommentSerializer < Api::V1::BaseSerializer
      attributes :id, :user_id, :body, :commentable_id, :commentable_type
    end
  end
end
