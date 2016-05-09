require 'test_helper'

class FriendlyForwardingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test 'get stats page via friendly forwarding' do
    get stats_path
    assert_redirected_to login_path
    assert_not_nil session[:forwarding_url]
    log_in_here(@user)
    assert_redirected_to stats_path
    assert_nil session[:forwarding_url]
  end
end
