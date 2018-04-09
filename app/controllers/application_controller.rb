# application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :check_current_user, :except => [:controller => :admin]
  # before_action :check_banned_user

  # private

  # def check_current_user
  # redirect_to static_pages_help_path unless current_user
  # end

  # def check_banned_user
  #  unless current_user[:banned_until].nil?
  #  end
  # end

  # def current_user
  #  unless current_admin_user
  #    return nil if session[:user_id].nil?
  #    begin
  #      User.find(session[:user_id])
  #    rescue ActiveRecord::RecordNotFound
  #      session[:user_id] = nil
  #    end
  #  end
  # end
  # helper_method :current_user
end
