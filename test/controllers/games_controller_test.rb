require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    @user = users(:dave)
  end

  test 'should get game page when no date is given' do
    get :game
    assert_response :success
  end

  test 'should get game page when a valid date is given' do
    # When not logged in...
    get :game, d: '2005-05-25'
    assert_response :success

    # ...when logged in and the date matches an existing game...
    log_in_here(@user)
    get :game, d: '2005-05-25'
    assert_response :success

    # ...and when there's no game for that date.
    get :game, d: '1776-07-04'
    assert_response :success
  end

  test 'should get game page when an invalid date is given' do
    # When not logged in...
    get :game, d: 'ThisIsNotADate'
    assert_response :success

    # ...or when logged in.
    log_in_here(@user)
    get :game, d: 'NeitherIsThis'
    assert_response :success
  end

  # TODO: Move this to an integration test.
  # test 'should request game when logged-in user gives a date' do
  #   log_in_here(@user)
  #   get :game, d: '2005-05-25'
  #   assert_response :success
  # end

  # TODO: Update this based on updated controller configuration.
  # test 'should redirect create when not logged in' do
  #   assert_no_difference 'Game.count' do
  #     post :create, game: { show_date: Time.zone.today, date_played: Time.zone.now }
  #   end
  #   assert_redirected_to login_url
  # end

  # test 'should redirect destroy when not logged in' do
  #   assert_no_difference 'Game.count' do
  #     delete :destroy, show_date: '2005-05-25'
  #   end
  #   assert_redirected_to login_url
  # end

  # test "should redirect destroy for wrong user's game" do
  #   log_in_here(@user)
  #   game = games(:steve)
  #   assert_no_difference 'Game.count' do
  #     delete :destroy, show_date: game.show_date
  #   end
  #   assert_redirected_to root_url
  # end
end
