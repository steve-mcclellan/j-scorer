require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: '', password: '' }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information followed by logout' do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert logged_in_here?
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'pages/home'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', stats_path
    delete logout_path
    assert_not logged_in_here?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', stats_path, count: 0
  end

  test 'login with remembering' do
    log_in_here(@user)
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
end
