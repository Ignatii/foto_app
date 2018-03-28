require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
ENV['RAILS_ENV'] ||= 'test'

class ActiveSupport::TestCase
  # parallelize(workers: 4)
  # Setup all fixtures in test/fixtures/*.yml for tests in alphabetical order.
  fixtures :all
  # current_user = users(:Ignatiy)
  # Add more helper methods to be used by all tests here...
end
