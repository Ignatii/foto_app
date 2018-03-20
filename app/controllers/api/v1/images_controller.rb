# images controller for API
class Api::V1::ImagesController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!

  def show
    image = Image.find_by(id: request.params['id'])
    render(json: Api::V1::ImageSerializer.new(image).to_json)
  end

  def index
    render(
      json: ActiveModel::ArraySerializer.new(
        Image.all.verified_image,
        each_serializer: Api::V1::ImageSerializer,
        root: 'images',
        # meta: meta_attributes(Image.all.verified_image)
      )
    )
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
      render json: { error: 'Image not uploaded' }, status: 401
    end
  end

  def upvote
    @image = Image.find(params['id'])
    if !current_user.voted_up_on?(@image)
        begin
          Redis.new.set('getstatus', 1)
          @image.upvote_by current_user
          IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score)
        rescue Redis::CannotConnectError
          @image.upvote_by @user
        end
        render(json: Api::V1::ImageSerializer.new(@image).to_json)
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: 'Current user already upvoted for this picture' }, status: 401
    end
  end

  def downvote
    @image = Image.find(params['id'])
    if !current_user.voted_down_on?(@image)
      begin
        Redis.new.set('getstatus', 1)
        @image.downvote_by current_user
        IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score)
      rescue Redis::CannotConnectError
        @image.downvote_by current_user
      end
      render(json: Api::V1::ImageSerializer.new(@image).to_json)
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: 'Current user already downvoted for this picture' }, status: 401
    end
  end
end
