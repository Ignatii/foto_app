# base controller for API
class Api::V1::BaseController < ActionController::API
  # protect_from_forgery with: :null_session
  before_action :destroy_session
  # before_action :current_user
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  # attr_accessor :current_user

  def destroy_session
    request.session_options[:skip] = true
  end

  def not_found
    api_error(status: 404, errors: 'Not found')
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = 'Token realm=Application'
    render json: { error: 'Bad credentials' }, status: :unauthorized
  end

  def disabled!
    response.headers['WWW-Authenticate'] = 'Token realm=Application'
    render json: { error: 'Api is disabled now!' }, status: :not_found
  end

  def authenticate_user!
    user = User.find_by(api_token: request.headers['HTTP_TOKEN_USER'])
    return unauthenticated! unless current_user
    return disabled! if redis_status == 'false' || redis_status.nil?
    return user if current_user && (redis_status == 'true')
  end

  def current_user
    @user = User.find_by(api_token: request.headers['HTTP_TOKEN_USER'])
    return @user if @user
  end

  private

  def redis_status
    Redis.new.get('api')
  rescue Redis::CannotConnectError
    'false'
  end
end
