# images controller for API
class Api::V1::ImagesController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!

  def show
    image = Image.find_by(id: request.params['id'])
    render(json: Api::V1::ImageSerializer.new(image).to_json)
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
      render json: { error: @images.errors.full_messages.to_sentence }, status: 401
  end

  def create
    if params.key?('image')
      image_param = Hash.new(image: params['image'])
      @images = current_user.images.build(image_param[:image])
      if @images.save
        render(json: Api::V1::ImageSerializer.new(@images).to_json)
      else
        response.headers['WWW-UPLOAD'] = 'Token realm=Application'
        render json: { error: 'Image not uploaded' }, status: 401
      end
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: 'Pass image!' }, status: 401
    end
  end

  def upvote_like
    @image = Image.find(params['id'])
    return (response.headers['WWW-UPLOAD'] = 'Token realm=Application') && (render json: { error: 'Current user already upvoted for this picture' }, status: 401) unless @image.likes.where(user_id: current_user.id).count == 0
    @image.likes.create(user_id: current_user.id)
    @image.update_attributes(likes_img: @image[:likes_img] + 1)
    begin
      Redis.new.set('getstatus', 1)   
      IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score_like)
    ensure
      render(json: Api::V1::ImageSerializer.new(@image).to_json)
    end
  end

  def downvote_like
    @image = Image.find(params['id'])
    debugger
    return (response.headers['WWW-UPLOAD'] = 'Token realm=Application') && (render json: { error: 'Current user didnt voted for this picture' }, status: 401) if @image.likes.where(user_id: current_user.id).count < 1
    Like.delete(Like.where(user_id: current_user.id,image_id: @image.id))
    @image.update_attributes(likes_img: @image[:likes_img] - 1) if @image[:likes_img] > 0
    begin
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score_like)
    ensure
      render(json: Api::V1::ImageSerializer.new(@image).to_json)
    end
  end
end
