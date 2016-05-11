require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @user = users(:dave)
    @game = @user.games.build(show_date: Date.new(1984, 9, 10),
                              date_played: Time.zone.today)
  end

  test 'should be valid' do
    assert @game.valid?
  end

  test 'user id should be present' do
    @game.user_id = nil
    assert_not @game.valid?
  end

  test 'show date should be present' do
    @game.show_date = nil
    assert_not @game.valid?
  end

  test 'default order should be most-recently-played first' do
    assert_equal games(:most_recent), Game.first
  end
end
