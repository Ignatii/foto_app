ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
#require "minitest/rails"

class ActiveSupport::TestCase
  OmniAuth.config.test_mode = true
  # parallelize(workers: 4)
  # Setup all fixtures in test/fixtures/*.yml for tests in alphabetical order.
  fixtures :all
  # current_user = users(:Ignatiy)
  # Add more helper methods to be used by all tests here...
  def sign_in
    session[:user_id] = User.first.id
  end
  def current_user
    User.find_by(id: session[:user_id])
  end
end
