# comments controller for API
class Api::V1::CommentsController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!
  def show
    comment = Comment.find_by(id: params['id'])
    if comment.nil?
      render json: { error: 'Not found' }, status: :not_found
    else
      render(json: Api::V1::CommentSerializer.new(comment).to_json)
    end
  end

  def index
    comments = Comment.all.where(user_id: current_user.id)
    if comments.nil?
      render json: { error: 'Not found' }, status: :not_found
    else
      render(
        json: ActiveModel::ArraySerializer.new(
          comments,
          each_serializer: Api::V1::CommentSerializer,
          root: 'comments',
          # meta: meta_attributes(Image.all.verified_image)
        )
      )
    end
  end

  def create
    par_f_com = { body: params['body'],
                  image_id: params['commentable_id_image'],
                  comment_id:  params['commentable_id_comment'] }
    result = CreateComments.run(params: par_f_com, user: current_user)
    # @comment = Comment.new
    # @comment.body = params['body']
    # @comment.user_id = current_user.id
    # @comment.commentable_id = params['commentable_id'].to_i
    # @comment.commentable_type = params['commentable_type']
    if result.valid?
      render(json: Api::V1::CommentSerializer.new(result.result).to_json)
    else
      response.headers['WWW-COMMENTS'] = 'Token realm=Application'
      render json: { error: 'Cant save comment.Check all required parametres' },
             status: :bad_request
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
