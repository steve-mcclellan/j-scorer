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

  test 'should redirect topics when not logged in' do
    get :topics, xhr: true
    assert_response :success
    assert_template 'pages/login_plz'
    assert_template layout: false
  end

  # TODO: This works properly outside of the test framework.
  #       Figure out how to test it!
  #       (Also, add tests for the other Ajax-only routes in config/routes.rb)
  # test 'should gripe when topics requested non-Ajax-style' do
  #   log_in_here(@user)
  #   get :topics
  #   assert_response :not_found
  # end

  test 'should get topics via Ajax request' do
    log_in_here(@user)
    get :topics, xhr: true
    assert_response :success
  end

  test 'should get sample_topics when not logged in' do
    get :sample_topics, xhr: true
    assert_response :success
  end

  test 'should get sample_topics when logged in' do
    log_in_here(@user)
    get :sample_topics, xhr: true
    assert_response :success
  end

  test 'should redirect update_user_types when not logged in' do
    patch :update_user_types, play_types: ['tenth'], xhr: true
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should overwrite play_types on a valid request' do
    log_in_here(@user)
    assert_equal ['regular'], @user.play_types
    patch :update_user_types, play_types: ['tenth'], xhr: true
    assert_response :success
    assert_equal ['tenth'], @user.reload.play_types
  end

  test 'should fail gracefully when given invalid types' do
    log_in_here(@user)
    assert_equal ['regular'], @user.play_types
    patch :update_user_types, play_types: 'not-an-array', xhr: true
    assert_response :bad_request
    assert_equal ['regular'], @user.reload.play_types
  end
end
