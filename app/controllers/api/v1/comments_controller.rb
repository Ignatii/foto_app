# comments controller for API
class Api::V1::CommentsController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!
  def show
    comment = Comment.find_by(id: request.params['id'])
    render(json: Api::V1::CommentSerializer.new(comment).to_json)
  end

  def index
    @comments = Comment.all.where(user_id: current_user.id)
    render(
      json: ActiveModel::ArraySerializer.new(
        @comments,
        each_serializer: Api::V1::CommentSerializer,
        root: 'comments',
        # meta: meta_attributes(Image.all.verified_image)
      )
    )
  end

  def create
    @comment = Comment.new
    @comment.body = params['body']
    @comment.user_id = current_user.id
    @comment.commentable_id = params['commentable_id'].to_i
    @comment.commentable_type = params['commentable_type']
    if @comment.save
      render(json: Api::V1::CommentSerializer.new(@comment).to_json)
    else
      response.headers['WWW-COMMENTS'] = 'Token realm=Application'
      render json: { error: 'Cant save comment.Check all required parametres' },
             status: :unauthorized
    end
  end

  def destroy
    @comment = Comment.find_by(id: params['id_comment'])
    if @comment
      if @comment.user_id == current_user.id
        @comment.destroy
        render json: { success: 'Comment deleted' }, status: :ok
      else
        response.headers['WWW-COMMENTS'] = 'Token realm=Application'
        render json: { error: 'You have no permission to delete this object' },
               status: :unauthorized
      end
    else
      response.headers['WWW-COMMENTS'] = 'Token realm=Application'
      render json: { error: 'Comment not found' }, status: :not_found
    end
  end
end
