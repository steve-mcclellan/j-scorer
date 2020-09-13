ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!
ActiveRecord::Migration.maintain_test_schema!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Returns true if a test user is logged in.
  def logged_in_here?
    !session[:user_id].nil?
  end

  # Logs in a test user.
  def log_in_here(user, options = {})
    password = options[:password] || 'password'
    if integration_test?
      post login_path, params: { session: { email: user.email,
                                            password: password } }
    else
      session[:user_id] = user.id
    end
  end

  private

  # Returns true inside an integration test.
  def integration_test?
    defined?(follow_redirect!)
  end
end
