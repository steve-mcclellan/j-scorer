require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:dave)
    remember(@user)
  end

  test 'current_user returns right user when session is nil' do
    assert_equal @user, current_user
    assert logged_in_here?
  end

  test 'current_user returns nil when remember digest is wrong' do
    # rubocop:disable SkipsModelValidations
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    # rubocop:enable SkipsModelValidations
    assert_nil current_user
  end
end
