# application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    I18n.locale = if params[:locale].present?
                    params[:locale].downcase || I18n.default_locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end
end
