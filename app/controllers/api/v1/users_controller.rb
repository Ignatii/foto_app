class Api::V1::UsersController < Api::V1::BaseController
  include ActiveHashRelation
  before_action :authenticate_user!, only: [:show, :index]
  def show
    #user = User.find_by(api_token: request.headers['HTTP_TOKEN_USER'])
    render(json: Api::V1::UserSerializer.new(current_user).to_json)
  end

  def index
  	#user = User.find_by(api_token: request.headers['HTTP_TOKEN_USER'])
  	render(json: Api::V1::UserSerializer.new(current_user).to_json)
  end
end
