# rubocop:disable ClassLength
require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    @user = users(:dave)
    @other_user = users(:steve)
  end

  test 'should get game page when no date is given' do
    # When not logged in...
    get :game
    assert_response :success

    # ... or when logged in.
    log_in_here(@user)
    get :game
    assert_response :success
  end

  test 'should get game page when a valid game_id is given' do
    # When not logged in...
    get :game, params: { g: '2005-05-25' }
    assert_response :success

    # ...when logged in and the game_id matches an existing game...
    log_in_here(@user)
    get :game, params: { g: '2005-05-25' }
    assert_response :success

    # ...and when there's no game for that game_id.
    get :game, params: { g: '1776-07-04' }
    assert_response :success
  end

  test 'should get game page when an invalid game_id is given' do
    # When not logged in...
    get :game, params: { g: 'ThisIsNotAGameId' }
    assert_response :success

    # ...or when logged in.
    log_in_here(@user)
    get :game, params: { g: 'NeitherIsThis' }
    assert_response :success
  end

  test "should successfully destroy the correct user's game" do
    log_in_here(@user)
    assert_difference '@user.games.count', -1 do
      delete :destroy, params: { game_id: '1984-09-11' }
    end
    assert_redirected_to stats_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Game.count' do
      delete :destroy, params: { game_id: '2005-05-25' }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy if id doesn't correspond to a game by user" do
    log_in_here(@user)
    game = games(:steve)
    assert_no_difference 'Game.count' do
      delete :destroy, params: { game_id: game.game_id }
    end
    assert_redirected_to root_url
  end

  test 'should get json for valid game_id' do
    log_in_here(@user)
    get :json, params: { game_id: games(:victoria) }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 6, body['round_one_categories'][0]['result3']
  end

  test 'json action should throw 404 for game_id with no game' do
    log_in_here(@user)
    get :json, params: { game_id: '1956-11-26' }
    assert_response :not_found
    assert_equal '{}', response.body
  end

  test 'should redirect json action when not logged in' do
    get :json, params: { game_id: games(:victoria) }
    assert_redirected_to login_url
  end

  # rubocop:enable ClassLength
  # rubocop:disable all
  test 'should redirect save when not logged in' do
    assert_no_difference 'Game.count' do
      post :save,
           params: { game: {"show_date"=>"1016-08-12", "date_played"=>"1016-08-12 10:56am", "play_type"=>"regular", "round_one_score"=>-3, "round_two_score"=>0, "final_result"=>0, "sixths_attributes"=>[{"id"=>nil, "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>1, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}], "final_attributes"=>{"id"=>nil, "category_title"=>"", "topics_string"=>"", "result"=>0, "third_right"=>nil, "second_right"=>nil, "first_right"=>nil}} }
    end
    assert_redirected_to login_url
  end

  test 'should redirect save when given invalid show date' do
    log_in_here(@user)
    assert_no_difference 'Game.count' do
      post :save,
           params: { game: {"show_date"=>"notAValidDate", "date_played"=>"1016-08-12 10:56am", "play_type"=>"regular", "round_one_score"=>-3, "round_two_score"=>0, "final_result"=>0, "sixths_attributes"=>[{"id"=>nil, "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>1, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}], "final_attributes"=>{"id"=>nil, "category_title"=>"", "topics_string"=>"", "result"=>0, "third_right"=>nil, "second_right"=>nil, "first_right"=>nil}} }
    end
    assert_redirected_to game_url
  end

  test 'game saving should work properly when logged in' do
    log_in_here(@user)

    # First, save a new game. This should be successful.
    assert_difference 'Game.count', 1 do
      post :save,
           params: { game: {"show_date"=>"1016-08-12", "date_played"=>"1016-08-12 10:56am", "play_type"=>"regular", "round_one_score"=>-3, "round_two_score"=>0, "final_result"=>0, "sixths_attributes"=>[{"id"=>nil, "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>1, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>nil, "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>nil, "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}], "final_attributes"=>{"id"=>nil, "category_title"=>"", "topics_string"=>"", "result"=>0, "third_right"=>nil, "second_right"=>nil, "first_right"=>nil}} }
    end
    body = JSON.parse(response.body)
    assert_nil body['errors']
    # Verify that the ids are present and non-nil.
    assert_equal 13, body['ids'].length
    assert body['ids'].all?
    this_game = @user.games.find_by(show_date: '1016-08-12')
    assert_equal(-3, this_game.round_one_score)

    # Grab data for future requests.
    ids = body['ids']

    # Second, resave the game with a single modification.
    assert_no_difference 'Game.count' do
      assert_no_difference 'Sixth.count' do
        post :save,
             params: { game: {"show_date"=>"1016-08-12", "date_played"=>"1016-08-12 10:56am", "play_type"=>"regular", "round_one_score"=>2, "round_two_score"=>0, "final_result"=>0, "sixths_attributes"=>[{"id"=>ids[0], "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[1], "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>7, "type"=>"RoundOneCategory"}, {"id"=>ids[2], "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[3], "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>1, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[4], "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[5], "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[6], "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[7], "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[8], "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[9], "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[10], "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[11], "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}], "final_attributes"=>{"id"=>ids[12], "category_title"=>"", "topics_string"=>"", "result"=>0, "third_right"=>nil, "second_right"=>nil, "first_right"=>nil}} }
      end
    end
    body = JSON.parse(response.body)
    assert_nil body['errors']
    # Verify that the ids are present and non-nil.
    assert_equal 13, body['ids'].length
    assert body['ids'].all?
    this_game = @user.games.reload.find_by(show_date: '1016-08-12')
    assert_equal 2, this_game.round_one_score

    # Third, try to resave the game with a different show date.
    # This should result in an error, as date changes are done elsewhere.
    assert_no_difference 'Game.count' do
      assert_no_difference 'Sixth.count' do
        post :save,
             params: { game: {"show_date"=>"3016-08-12", "date_played"=>"1016-08-12 10:56am", "play_type"=>"regular", "round_one_score"=>-2, "round_two_score"=>0, "final_result"=>0, "sixths_attributes"=>[{"id"=>ids[0], "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[1], "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>1, "result5"=>7, "type"=>"RoundOneCategory"}, {"id"=>ids[2], "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[3], "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>1, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[4], "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[5], "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundOneCategory"}, {"id"=>ids[6], "board_position"=>1, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[7], "board_position"=>2, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[8], "board_position"=>3, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[9], "board_position"=>4, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[10], "board_position"=>5, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}, {"id"=>ids[11], "board_position"=>6, "title"=>"", "topics_string"=>"", "result1"=>0, "result2"=>0, "result3"=>0, "result4"=>0, "result5"=>0, "type"=>"RoundTwoCategory"}], "final_attributes"=>{"id"=>ids[12], "category_title"=>"", "topics_string"=>"", "result"=>0, "third_right"=>nil, "second_right"=>nil, "first_right"=>nil}} }
      end
    end
    body = JSON.parse(response.body)
    assert_response :bad_request
    assert_equal 'Invalid change', body['date'][0]
    this_game = @user.games.reload.find_by(show_date: '1016-08-12')
    assert_equal 2, this_game.round_one_score
  end

  # rubocop:enable all

  test 'should redirect redate action when not logged in' do
    patch :redate,
          params: { finalID: 470,
                    oldDate: '2005-05-25',
                    newDate: '2222-02-22' }
    assert_redirected_to login_url
  end

  test 'redate action should return error for invalid date format' do
    log_in_here(@user)
    patch :redate,
          params: { finalID: 470,
                    oldDate: 'notADate',
                    newDate: 'notADateEither' }
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_equal 'bad_date', body['errors'][0]

    patch :redate,
          params: { finalID: 470,
                    oldDate: 'notADate',
                    newDate: '2016-09-22' }
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_equal 'bad_date', body['errors'][0]

    patch :redate,
          params: { finalID: 470,
                    oldDate: '2005-05-25',
                    newDate: 'notADate' }
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_equal 'bad_date', body['errors'][0]
    assert_not_nil @user.reload.games.find_by(game_id: '2005-05-25')
  end

  test 'redate action should return error for bad oldDate/finalID combo' do
    log_in_here(@user)
    patch :redate,
          params: { finalID: 470,
                    oldDate: '1983-07-18',
                    newDate: '2083-07-18' }
    assert_response :not_found
    body = JSON.parse(response.body)
    assert_equal 'no_show', body['errors'][0]

    patch :redate,
          params: { finalID: 525,
                    oldDate: '2005-05-25',
                    newDate: '2250-05-25' }
    assert_response :not_found
    body = JSON.parse(response.body)
    assert_equal 'no_show', body['errors'][0]
  end

  test 'redate action should work when given valid data' do
    log_in_here(@user)
    patch :redate,
          params: { finalID: 470,
                    oldDate: '2005-05-25',
                    newDate: '2345-01-23' }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal true, body['success']
    assert_nil @user.reload.games.find_by(game_id: '2005-05-25')
    assert_not_nil @user.reload.games.find_by(game_id: '2345-01-23')
  end

  test 'redate action should work even if newDate already has a game' do
    log_in_here(@user)
    patch :redate,
          params: { finalID: 470,
                    oldDate: '2005-05-25',
                    newDate: '1984-09-10' }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal true, body['success']
    assert_nil @user.reload.games.find_by(game_id: '2005-05-25')
    assert_not_nil @user.reload.games.find_by(game_id: '1984-09-10-1')
  end

  test 'check action should return empty string when not logged in' do
    get :check, params: { final_id: 1 }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal '', body['match']
  end

  test 'check action should return true when final belongs to current user' do
    log_in_here(@user)
    get :check, params: { final_id: finals(:fone).id }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal true, body['match']
  end

  test "check action should return empty string if other user's game" do
    log_in_here(@other_user)
    get :check, params: { final_id: finals(:fone).id }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal '', body['match']
  end

  test 'check action should return empty string if given invalid final_id' do
    log_in_here(@user)
    get :check, params: { final_id: 'meatball' }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal '', body['match']
  end
end
