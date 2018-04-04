ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require "minitest/rails"

# Load fixtures from the engine
# if ActiveSupport::TestCase.respond_to?(:fixture_path=)
#   ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
# end

# class ActiveSupport::TestCase
#   # Add spec DSL
#   extend Minitest::Spec::DSL
#   register_spec_type(self) do |desc|
#     desc < ActiveRecord::Base if desc.is_a?(Class)
#   end
# end

# class ActiveSupport::TestCase
#   # Use AS::TestCase for the base class when describing a model
#   register_spec_type(self) do |desc|
#     desc < ActiveRecord::Base if desc.is_a?(Class)
#   end
# end

class ActiveSupport::TestCase
  OmniAuth.config.test_mode = true
  # parallelize(workers: 4)
  # Setup all fixtures in test/fixtures/*.yml for tests in alphabetical order.
  fixtures :all
  # extend MiniTest::Spec::DSL
  # register_spec_type self do |desc|
  #   desc < ActiveRecord::Base if desc.is_a? Class
  # end
  # current_user = users(:Ignatiy)
  # Add more helper methods to be used by all tests here...
  def sign_in
    session[:user_id] = User.first.id
  end

  def sign_in_api
    current_user = User.find_by(api_token: request.headers['TOKEN_USER'])
  end

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
