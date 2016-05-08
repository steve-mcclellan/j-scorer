require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { email: 'user@invalid',
                               password: 'foo',
                               password_confirmation: 'bar' }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { email: 'user@example.com',
                                            password: 'password',
                                            password_confirmation: 'password' }
    end
    assert_template 'pages/home'
    assert logged_in_here?
    assert_not flash.empty?
  end
end
