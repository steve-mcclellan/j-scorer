require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:dave)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should redirect show (stats page) when not logged in' do
    get :show
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should show stats page when logged in' do
    log_in_here(@user)
    get :show
    assert flash.empty?
    assert_response :success
  end

  test 'should get sample when not logged in' do
    get :sample
    assert_response :success
  end

  test 'should get sample when logged in' do
    log_in_here(@user)
    get :sample
    assert_response :success
  end

  test 'should redirect update_user_filters when not logged in' do
    patch :update_user_filters, params: { play_types: ['tenth'] }, xhr: true
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should overwrite play types on a valid update_user_filters request' do
    log_in_here(@user)
    assert_equal ['regular'], @user.play_types
    patch :update_user_filters, params: { play_types: ['tenth'] }, xhr: true
    assert_response :success
    assert_equal ['tenth'], @user.reload.play_types
  end

  test 'should filter out invalid play types' do
    log_in_here(@user)
    assert_equal ['regular'], @user.play_types
    # rubocop:disable WordArray
    patch :update_user_filters, params: { play_types: ['not_a_type', 'kids'] },
                                xhr: true
    # rubocop:enable WordArray
    assert_response :success
    assert_equal ['kids'], @user.reload.play_types
  end

  test 'should fail gracefully when update_user_filters given invalid types' do
    log_in_here(@user)
    assert_equal ['regular'], @user.play_types
    patch :update_user_filters, params: { play_types: 'not-an-array' },
                                xhr: true
    assert_response :bad_request
    assert_equal ['regular'], @user.reload.play_types
  end

  test 'should display sample even when bad params are passed' do
    get :sample, params: { play_types: 'utoc,xxx',
                           show_date_preposition: 'since',
                           show_date_from: 'not-a-date' }
    assert_response :success
  end
end
