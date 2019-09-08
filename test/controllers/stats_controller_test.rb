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

  test 'should redirect topic when not logged in' do
    get :topic, params: { name: 'InQuotes' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should display valid topic when logged in' do
    log_in_here(@user)
    get :topic, params: { name: 'InQuotes' }
    assert flash.empty?
    assert_response :success
    assert_select 'title', 'J! Scorer - Topic stats'
    assert_includes response.body, 'Potpourri'
    assert_includes response.body, @user.shared_stats_name # should be email
  end

  test 'should 404 topic when given a non-existent topic' do
    log_in_here(@user)
    get :topic, params: { name: 'IAmNotATopic' }
    assert_response :not_found
  end

  test 'should get valid sample topic when not logged in' do
    get :sample_topic, params: { name: 'Lowbrow' }
    assert flash.empty?
    assert_response :success
    assert_includes response.body, 'Lowbrow'
    assert_includes response.body, @user.shared_stats_name # should be email
  end

  test 'should get valid sample topic when logged in' do
    log_in_here(@other_user)
    get :sample_topic, params: { name: 'Lowbrow' }
    assert flash.empty?
    assert_response :success
    assert_includes response.body, 'Lowbrow'
    assert_includes response.body, @user.shared_stats_name # should be email
  end

  test 'should 404 non-existent sample topic' do
    get :sample_topic, params: { name: 'TrinidadianProfessionalIchthyologists' }
    assert_response :not_found
    log_in_here(@other_user)
    get :sample_topic, params: { name: 'TrinidadianProfessionalIchthyologists' }
    assert_response :not_found
  end

  test 'shared topic should 404 bad user name' do
    get :shared_topic, params: { name: 'NotAUser', topic: 'General' }
    assert_response :not_found
    log_in_here(@user)
    get :shared_topic, params: { name: 'NotAUser', topic: 'General' }
    assert_response :not_found
  end

  test 'shared topic should 404 for summary-stats-only user' do
    get :shared_topic, params: { name: @other_user.shared_stats_name,
                                 topic: 'General' }
    assert_response :not_found
    log_in_here(@user)
    get :shared_topic, params: { name: @other_user.shared_stats_name,
                                 topic: 'General' }
    assert_response :not_found
  end

  test 'shared topic should 404 on non-existent topic' do
    @other_user.share_detailed_stats = true
    get :shared_topic, params: { name: @other_user.shared_stats_name,
                                 topic: 'NotATopic' }
    assert_response :not_found
    log_in_here(@user)
    get :shared_topic, params: { name: @other_user.shared_stats_name,
                                 topic: 'NotATopic' }
    assert_response :not_found
  end

  test 'shared topic should actually work if request is good' do
    @other_user.share_detailed_stats = true
    get :shared_topic, params: { name: 'Highbrow' }
    assert flash.empty?
    assert_response :success
    assert_select 'title', 'J! Scorer - Shared topic stats'
    assert_includes response.body, 'Potpourri'
    assert_includes response.body, @user.email # should be shared_stats_name
    log_in_here(@user)
    get :shared_topic, params: { name: 'Highbrow' }
    assert flash.empty?
    assert_response :success
    assert_select 'title', 'J! Scorer - Shared topic stats'
    assert_includes response.body, 'Potpourri'
    assert_includes response.body, @user.email # should be shared_stats_name
  end
end
