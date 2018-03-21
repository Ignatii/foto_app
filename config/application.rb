require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(*Rails.groups)
Bundler.require(:default, :assets, Rails.env)

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
    config.load_defaults 5.1
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }
    config.assets.initialize_on_precompile = false
    config.autoload_paths += Dir.glob("#{config.root}/app/interactions/*")
    config.assets.enabled = true
    config.assets.version = '1.0'
    # Settings in config/environments/*
    # take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
