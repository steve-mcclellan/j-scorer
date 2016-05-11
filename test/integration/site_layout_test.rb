require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test 'layout links' do
    get root_path
    assert_template 'pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', stats_path, count: 0
    assert_select 'a[href=?]', logout_path, count: 0
    log_in_here @user
    get root_path
    assert_template 'pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', signup_path, count: 0
    assert_select 'a[href=?]', stats_path, count: 3
    assert_select 'a[href=?]', logout_path
  end

  test 'signup page should show up' do
    get signup_path
    assert_select 'title', 'J! Scorer - Sign up'
  end
end
