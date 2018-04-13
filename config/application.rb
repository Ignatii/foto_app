require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
# require 'active_model/railtie'
# require 'active_job/railtie'
# require 'active_record/railtie'
# require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'sidekiq/web'

module FotoApp
  # config for app
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.before_configuration do
      I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
      I18n.default_locale = :ru
      I18n.reload!
    end
    # config.force_ssl = true
    # config.after_initialize do |app|
    #   if defined?(ActiveAdmin) and ActiveAdmin.application
    #     # Try enforce reloading after app bootup
    #     Rails.logger.debug("Reloading AA")
    #     ActiveAdmin.application.unload!
    #     I18n.reload!
    #     self.reload_routes!
    #   end
    # end
    config.load_defaults 5.1
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }
    config.assets.initialize_on_precompile = false
    config.autoload_paths += Dir.glob("#{config.root}/app/interactions/*")
    config.autoload_paths += Dir[Rails.root.join('app/services/**/*.rb')].each{|rb| require rb}
    config.encoding = "utf-8"
    config.middleware.insert_before(Rack::Sendfile, StackProf::Middleware, enabled: true, mode: :cpu, interval: 1000, save_every: 5)
    # Settings in config/environments/*
    # take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
