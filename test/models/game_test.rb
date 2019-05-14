require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @user = users(:dave)
    @game = @user.games.create!(show_date: Date.new(1984, 9, 12),
                                play_type: 'regular',
                                date_played: 1.day.ago)
  end

  test 'should be valid' do
    assert @game.valid?
  end

  test 'user should be present' do
    @game.user = nil
    assert_not @game.valid?
  end

  test 'play type should be present' do
    @game.play_type = nil
    assert_not @game.valid?
  end

  test 'play type should be in the PLAY_TYPES hash' do
    @game.play_type = 'armed'
    assert @game.valid?

    @game.play_type = 'user-defined-type'
    assert_not @game.valid?
  end

  test 'show date should be present' do
    @game.show_date = nil
    assert_not @game.valid?
  end

  test 'game_id should auto-set to the appropriate value' do
    new_game = @user.games.build(show_date: Date.new(1984, 9, 12),
                                 date_played: Time.zone.today)
    assert_nil new_game.game_id
    assert new_game.valid?
    new_game.save!
    assert_equal '1984-09-12-1', new_game.game_id

    # A different user should be able to have an independent game_id.
    other_game = users(:steve).games.build(show_date: Date.new(1984, 9, 12),
                                           date_played: Time.zone.today)
    assert_nil other_game.game_id
    assert other_game.valid?
    other_game.save!
    assert_equal '1984-09-12', other_game.game_id
  end

  test 'default order should be most-recently-played first' do
    assert_equal games(:most_recent), Game.first
  end
end
