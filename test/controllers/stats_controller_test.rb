require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  def setup
    @user = users(:dave)
    @other_user = users(:steve)
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

  test 'should get valid shared page when not logged in' do
    get :shared, params: { name: @other_user.shared_stats_name }
    assert_response :success
  end

  test 'should get valid shared page when logged in' do
    log_in_here(@user)
    get :shared, params: { name: @other_user.shared_stats_name }
    assert_response :success
  end

  test 'should 404 invalid shared page when not logged in' do
    get :shared, params: { name: 'BadName' }
    assert_response :not_found
  end

  test 'should 404 invalid shared page when logged in' do
    log_in_here(@user)
    get :shared, params: { name: 'BadName' }
    assert_response :not_found
  end

  test 'should display sample even when bad params are passed' do
    get :sample, params: { play_types: 'utoc,xxx',
                           show_date_preposition: 'since',
                           show_date_from: 'not-a-date' }
    assert_response :success
  end
end
