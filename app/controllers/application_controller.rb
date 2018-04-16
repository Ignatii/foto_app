# application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    if !params[:locale].nil?
      I18n.locale = params[:locale].downcase || I18n.default_locale
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
