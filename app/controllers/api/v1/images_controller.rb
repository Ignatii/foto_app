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
      render json: { error: @images.errors.full_messages.to_sentence },
             status: :unauthorized
    end
  end

  def groupping_answer
    # Image.all.order(likes_count: :DESC).group_by(&:user)
    # Image.all.order(likes_count: :DESC).select('images.id,images.user_id').includes(:user).select('users.id as id_u').group('id_u')
    # a=Image.all.order(likes_count: :DESC).pluck(:user_id)
    # User.all.where("id in (#{a.join(',')})").includes(:images)
    users = Image.all.joins(:user).group(:user_id)
    array = []
    users.each do |user|
      array.push(Image.all.select(:id,
                                  :user_id,
                                  :aasm_state,
                                  :likes_count).where(user: user.user))
    end
    render :json => array, each_serializer: Api::V1::ImageSerializer
    # render(array.to_json)
    # if !array.nil?
    #   render(
    #     json: ActiveModel::ArraySerializer.new(
    #       array,
    #       each_serializer: Api::V1::ImageSerializer
    #       # root: 'images',
    #       # meta: meta_attributes(Image.all.verified_image)
    #     )
    #   )
    # else
    #   response.headers['WWW-UPLOAD'] = 'Token realm=Application'
    #   render json: { error: @images.errors.full_messages.to_sentence },
    #          status: :unauthorized
    # end
  end

  def create
    if params.key?('image')
      image_param = Hash.new(image: params['image'])
      @images = current_user.images.build(image_param[:image])
      if @images.save
        render(json: Api::V1::ImageSerializer.new(@images).to_json)
      else
        response.headers['WWW-UPLOAD'] = 'Token realm=Application'
        render json: { error: 'Image not uploaded' }, status: :unauthorized
      end
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: 'Pass image!' }, status: :unauthorized
    end
  end

  def upvote_like
    @image = Image.find(params['id'])
    return (response.headers['WWW-UPLOAD'] = 'Token realm=Application') && (render json: { error: 'Current user already upvoted for this picture' }, status: :unauthorized) unless @image.likes.where(user_id: current_user.id).count.zero?
    @image.likes.create(user_id: current_user.id)
    @image.update(likes_img: @image[:likes_img] + 1)
    begin
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score_like)
    ensure
      render(json: Api::V1::ImageSerializer.new(@image).to_json)
    end
  end

  def downvote_like
    @image = Image.find(params['id'])
    return (response.headers['WWW-UPLOAD'] = 'Token realm=Application') && (render json: { error: 'Current user didnt voted for this picture' }, status: :unauthorized) if @image.likes.where(user_id: current_user.id).count < 1
    Like.delete(Like.where(user_id: current_user.id, image_id: @image.id))
    condition = @image[:likes_img].positive?
    @image.update(likes_img: @image[:likes_img] - 1) if condition
    begin
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score_like)
    ensure
      render(json: Api::V1::ImageSerializer.new(@image).to_json)
    end
  end
end
