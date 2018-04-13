# users controller for API
class Api::V1::UsersController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!, only: %i[show index]
  def show
    render(json: Api::V1::UserSerializer.new(current_user).to_json)
  end

  def index
    ids = User.all.includes(:images).group('users.id').sum('images.likes_count')
    # render(json: Api::V1::UserSerializer.new(User.all).to_json)
    render(
      json: ActiveModel::ArraySerializer.new(
        User.where("id in (#{ids.keys.join(',')})"),
        each_serializer: Api::V1::UserSerializer,
        root: 'users',
        # meta: meta_attributes(Image.all.verified_image)
      )
    )
  end
end
