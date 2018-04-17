# session controller app
class SessionsController < ApplicationController
  skip_before_action :set_locale
  def create
    if auth_hash
      result = Session::Create.run(session: session,
                                   auth_hash: request.env['omniauth.auth'])
      user = result.result
    end
    redirect_to user_path(user)
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
