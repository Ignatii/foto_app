# comments controller for API
module Api
  module V1
    class CommentsController < Api::V1::BaseController
      include ActiveHashRelation
      before_action :authenticate_user!
      def show
        comment = Comment.find_by(id: params['id'])
        if comment.nil?
          render json: { error: 'Not found' }, status: :not_found
        else
          render json: comment, serializer: Api::V1::CommentSerializer
        end
      end

      def index
        comments = Comment.all.where(user_id: current_user.id)
        render(
          json: ActiveModel::ArraySerializer.new(
            comments,
            each_serializer: Api::V1::CommentSerializer,
            root: 'comments'
          )
        )
      end

      def create
        new_comment = Comments::Create.run(params.merge(user: current_user))
        if new_comment.valid?
          render(json: Api::V1::CommentSerializer.new(new_comment.result).to_json)
        else
          render json: { error: 'Cant save comment.Check all required parametres' },
                 status: :bad_request
        end
      end

      def destroy
        destroy_comment = Comments::DestroyCustom.run(params['id'].merge(user: current_user))
        if destroy_comment.valid?
          render json: { success: 'Comment deleted' }, status: :ok
        else
          render json: { error: destroy_comment.errors.details },
                 status: :bad_request
        end
      end
    end
  end
end
