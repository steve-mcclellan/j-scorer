require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @user = users(:dave)
    @game = @user.games.create!(show_date: Date.new(1984, 9, 12),
                                date_played: 1.day.ago)
  end

  test 'should be valid' do
    assert @game.valid?
  end

  test 'user id should be present' do
    @game.user_id = nil
    assert_not @game.valid?
  end

  test 'show date should be present and unique on a per-user basis' do
    @game.show_date = nil
    assert_not @game.valid?
    game2 = @user.games.build(show_date: Time.zone.today,
                              date_played: Time.zone.today)
    assert game2.valid?
    game2.show_date = Date.new(1984, 9, 12)
    assert_not game2.valid?
    # A different user should be able to have the same day's game.
    other_users_game = users(:steve).games.build(show_date: Date.new(1984, 9, 12),
                                                 date_played: Time.zone.today)
    assert other_users_game.valid?
  end

  test 'default order should be most-recently-played first' do
    assert_equal games(:most_recent), Game.first
  end
end
