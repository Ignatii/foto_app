# session controller for API
class Api::V1::SessionsController < Api::V1::BaseController
  def create
    # user = User.find_by(api_token: request.headers['HTTP_TOKEN_USER'])
    result = ApiFindUser.run(request.headers['HTTP_TOKEN_USER'])
    if result.valid?
      self.current_user = result.result
      render(
        json: Api::V1::SessionSerializer.new(current_user, root: false).to_json,
        status: :created
      )
    else
      response.headers['WWW-UPLOAD'] = 'Token realm=Application'
      render json: { error: result.errors.full_messages.to_sentence },
             status: :unauthorized
    end
  end
  # private
  # def create_params
  #  params.require(:user).permit(:email, :password)
  # end
end
