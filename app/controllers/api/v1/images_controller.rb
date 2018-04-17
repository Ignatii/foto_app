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
    @images = Images::List.run(params).result.page(params[:page]).per(12)
    if @images.present?
      render(
        json: Api::V1::PaginationSerializer.new(
          @images,
          each_serializer: Api::V1::ImageSerializer,
          root: 'images'
          # meta: { current_page: @images.current_page,
          #         next_page: @images.next_page,
          #         prev_page: @images.prev_page,
          #         total_pages: @images.total_pages,
          #         total_count: @images.total_count
          # }
        )
      )
      # render json: @images, serializer: Api::V1::PaginationSerializer
    else
      render json: { error: @images.errors.full_messages.to_sentence },
             status: :bad_request
    end
  end

  def groupping_answer
    images_groupes = Images::Group.run!
    if images_groupes.valid?
      # render json: images_groupes.result, each_serializer: Api::V1::ImageSerializer
      render(
        json: ActiveModel::ArraySerializer.new(
          images_groupes,
          each_serializer: Api::V1::ImageSerializer,
          root: 'images'
        )
      )
    else
      render json: { error: images_groupes.errors.details },
             status: :bad_request
    end
  end

  def create
    create_image = Images::Create.run(params.merge(user: current_user))
    if create_image.valid?
      render(json: Api::V1::ImageSerializer.new(create_image.result).to_json)
    else
      render json: { error: create_image.errors.details }, status: :bad_request
    end
  end

  def upvote_like
    upvote_image = Images::LikeInt.run(params.merge(user: current_user))
    if upvote_image.valid?
      render(json: Api::V1::ImageSerializer.new(result.result).to_json)
    else
      render json: { error: upvote_image.errors.details }, status: :bad_request
    end
  end

  def downvote_like
    downvote_image = Images::Dislike.run(params.merge(user: current_user))
    if downvote_image.valid?
      render(json: Api::V1::ImageSerializer.new(result.result).to_json)
    else
      render json: { error: downvote_image.errors.details }, status: :bad_request
    end
  end
end
