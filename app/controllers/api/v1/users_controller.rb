# users controller for API
class Api::V1::UsersController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!, only: %i[show index]
  def show
    render(json: Api::V1::UserSerializer.new(current_user).to_json)
  end

  def index
    result = Api::FindUsers.run!
    if result.valid?
      render(
        json: ActiveModel::ArraySerializer.new(
          User.where("id in (#{ids.keys.join(',')})"),
          each_serializer: Api::V1::UserSerializer,
          root: 'users',
          # meta: meta_attributes(Image.all.verified_image)
        )
      )
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: result.errors.full_messages.to_sentence },
             status: :unauthorized
    end
  end
end
