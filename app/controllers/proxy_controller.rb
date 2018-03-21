# class for bordering classes who use check_current_user&check_banned_user
class ProxyController < ApplicationController
  protect_from_forgery with: :exception
  before_action :check_current_user
  before_action :check_banned_user

  private

  def check_current_user
    redirect_to static_pages_help_path unless current_user
  end

  def check_banned_user
    if current_user
      unless current_user[:banned_until].nil?
        redirect_to static_pages_help_path unless current_user[:banned_until] < Time.current
      end
    end
  end

  def current_user
    return false if session[:user_id].nil?
    begin
      User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      session[:user_id] = nil
    end
  end
  helper_method :current_user
end
