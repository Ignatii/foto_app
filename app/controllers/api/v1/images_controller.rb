# images controller for API
class Api::V1::ImagesController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!

  def show
    image = Image.find_by(id: params['id'])
    if image.nil?
      render json: { error: 'Image not found' }, status: :not_found
    else
      render(json: Api::V1::ImageSerializer.new(image).to_json)
    end
  end

  def index
    @images = ListImages.run!.page(params[:page]).per(12)
    if @images.valid?
      render(
        json: ActiveModel::ArraySerializer.new(
          ListImages.run!.page(params[:page]).per(12),
          each_serializer: Api::V1::ImageSerializer,
          root: 'images',
          # meta: meta_attributes(Image.all.verified_image)
        )
      )
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: @images.errors.full_messages.to_sentence },
             status: :bad_request
    end
  end

  def groupping_answer
    # a=Image.all.order(likes_count: :DESC).pluck(:user_id)
    # User.all.where("id in (#{a.join(',')})").includes(:images)
    result = GroupImages.run!
    if result.valid?
      render json: array, each_serializer: Api::V1::ImageSerializer
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: @images.errors.full_messages.to_sentence },
             status: :bad_request
    end
  end

  def create
    if params.key?('image')
      params = { image: params['image'],
                 title_img: params['title_img'],
                 tags: params['tags'],
                 user_id: current_user }
      result = CreateImages.run(params)
      # image_param = Hash.new(image: params['image'])
      # @images = current_user.images.build(image_param[:image])
      if result.valid?
        render(json: Api::V1::ImageSerializer.new(result.result).to_json)
      else
        response.headers['WWW-UPLOAD'] = 'Token realm=Application'
        error = result.errors.full_messages.to_sentence
        render json: { error: error }, status: :bad_request
      end
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: 'Pass image!' }, status: :bad_request
    end
  end

  def upvote_like
    result = LikeImages.run(image_id: params['id'], user: current_user)
    if result.valid?
      render(json: Api::V1::ImageSerializer.new(result.result).to_json)
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      error = result.errors.full_messages.to_sentence
      render json: { error: error }, status: :bad_request
    end
    # @image = Image.find(params['id'])
    # return (response.headers['WWW-UPLOAD'] = 'Token realm=Application')
    # && (render json: { error: 'Current user already upvoted for this picture'
    # }, status: :unauthorized) unless @image.likes.where(user_id:
    # current_user.id).count.zero?
    # @image.likes.create(user_id: current_user.id)
    # @image.update(likes_img: @image[:likes_img] + 1)
    # begin
    #   Redis.new.set('getstatus', 1)
    #   IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score_like)
    # ensure
    #   render(json: Api::V1::ImageSerializer.new(@image).to_json)
    # end
  end

  def downvote_like
    result = DislikeImages.run(image_id: params['id'], user: current_user)
    if result.valid?
      render(json: Api::V1::ImageSerializer.new(result.result).to_json)
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      error = result.errors.full_messages.to_sentence
      render json: { error: error }, status: :bad_request
    end
    # @image = Image.find(params['id'])
    # return (response.headers['WWW-UPLOAD'] = 'Token realm=Application')
    # && (render json: { error: 'Current user didnt voted for this picture' },
    # status: :unauthorized) if @image.likes.where(user_id:
    # current_user.id).count < 1
    # Like.delete(Like.where(user_id: current_user.id, image_id: @image.id))
    # condition = @image[:likes_img].positive?
    # @image.update(likes_img: @image[:likes_img] - 1) if condition
    # begin
    #   Redis.new.set('getstatus', 1)
    #   IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score_like)
    # ensure
    #   render(json: Api::V1::ImageSerializer.new(@image).to_json)
    # end
  end
end
