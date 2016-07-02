require 'test_helper'

class GamesInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test 'game interface' do
    log_in_here(@user)
    get root_path
    assert_template 'pages/home'
    # Invalid submission
    # TODO: Modify this based on updated controller actions.
    # assert_no_difference 'Game.count' do
    #   post games_path, game: { show_date: '', date_played: '' }
    # end
    # TODO: Redo this whole test.
    # assert_select 'div#error_explanation'
    # Valid submission
    # show_date = Date.new(1983, 7, 18)
    # date_played = Time.zone.now
    # TODO: See previous TODOs.
    # assert_difference 'Game.count', 1 do
    #   post games_path, game: { show_date: show_date, date_played: date_played }
    # end
    # assert_redirected_to stats_url
    # follow_redirect!
    # assert_match '1983', response.body
    # Delete a game.
    # assert_select 'a', text: 'delete'
    # first_game = @user.games.first
    # assert_difference 'Game.count', -1 do
    #   delete game_path(first_game.show_date)
    # end
  end
end
