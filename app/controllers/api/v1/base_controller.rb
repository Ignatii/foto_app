class Api::V1::BaseController < ActionController::API
  #protect_from_forgery with: :null_session
  before_action :destroy_session
  #before_action :current_user
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  #attr_accessor :current_user

  def destroy_session
    request.session_options[:skip] = true
  end

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = "Token realm=Application"
    render json: { error: 'Bad credentials' }, status: 401
  end

  def authenticate_user!
    user = User.find_by(api_token: request.headers['HTTP_TOKEN_USER'])
    if user
      #@current_user = user
      current_user
    else
      return unauthenticated!
    end
  end

  def current_user
    if request.headers['HTTP_TOKEN_USER']
      return User.find_by(api_token: request.headers['HTTP_TOKEN_USER'])
    else
      return nil
    end
  end
end

