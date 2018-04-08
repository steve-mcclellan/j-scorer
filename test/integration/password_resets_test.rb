require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:dave)
  end

  test 'password resets' do
    get forgot_path
    assert_template 'password_resets/new'
    # Invalid email
    post forgot_path, params: { password_reset: { email: '' } }
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Valid email
    post forgot_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # Right email, wrong token
    get reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # Invalid password & confirmation
    patch reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'barquux' } }
    assert_select 'div#error_explanation'
    # Empty password
    patch reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: '',
                            password_confirmation: '' } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'foobaz' } }
    assert logged_in_here?
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'expired token' do
    get forgot_path
    post forgot_path, params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    # rubocop:disable SkipsModelValidations
    @user.update_attribute(:reset_sent_at, 90.minutes.ago)
    # rubocop:enable SkipsModelValidations
    patch reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password: 'foobar',
                            password_confirmation: 'foobar' } }
    assert_response :redirect
    follow_redirect!
    assert_match(/expired/i, response.body)
  end
end
