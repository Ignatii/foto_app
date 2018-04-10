# users controller for API
class Api::V1::UsersController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!, only: %i[show index]
  def show
    render(json: Api::V1::UserSerializer.new(current_user).to_json)
  end

  def index
    render(json: Api::V1::UserSerializer.new(current_user).to_json)
  end
end
