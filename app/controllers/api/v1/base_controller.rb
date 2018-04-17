# base controller for API
class Api::V1::BaseController < ActionController::API
  before_action :destroy_session
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def destroy_session
    request.session_options[:skip] = true
  end

  def not_found
    api_error(status: 404, errors: 'Not found')
  end

  def unauthenticated!
    render json: { error: 'Bad credentials' }, status: :unauthorized
  end

  def disabled!
    render json: { error: 'Api is disabled now!' }, status: :not_found
  end

  def authenticate_user!
    return unauthenticated! unless current_user
    return disabled! unless redis_status
    return current_user if current_user && redis_status
  end

  def current_user
    @current_user ||= User.find_by(api_token: request.headers['HTTP_TOKEN_USER'])
  end

  private

  def redis_status
    Redis.new.get('api') == 'true'
  rescue Redis::CannotConnectError
    false
  end
end
