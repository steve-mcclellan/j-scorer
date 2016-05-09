require 'test_helper'

class FriendlyForwardingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test 'get stats page via friendly forwarding' do
    get stats_path
    assert_redirected_to login_path
    log_in_here(@user)
    assert_redirected_to stats_path
  end
end
