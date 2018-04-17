# users controller for API
class Api::V1::UsersController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!, only: %i[show index]
  def show
    render(json: Api::V1::UserSerializer.new(current_user).to_json)
  end

  def index
    find_users = Api::FindUsers.run!
    if find_users.valid?
      render(
        json: ActiveModel::ArraySerializer.new(
          result.result,
          each_serializer: Api::V1::UserSerializer,
          root: 'users'
        )
      )
    else
      render json: { error: find_users.errors.details },
             status: :unauthorized
    end
  end
end
