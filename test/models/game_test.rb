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

  test 'clues right and wrong should be auto-set correctly' do
    new_game = @user.games.build(show_date: Date.new(1984, 9, 13),
                                 date_played: Time.zone.today)
    assert_nil new_game.clues_right
    assert_nil new_game.clues_wrong
    new_game.save!
    assert_equal 0, new_game.clues_right
    assert_equal 0, new_game.clues_wrong

    new_game.round_one_categories.create!(board_position: 2, result3: 3)
    new_game.round_one_categories.create!(board_position: 3, result2: 3)
    # DD hit shouldn't count
    new_game.round_one_categories.create!(board_position: 4, result2: 7)
    new_game.round_two_categories.create!(board_position: 5, result4: 1)
    # DD miss shouldn't count
    new_game.round_two_categories.create!(board_position: 6, result4: 6)

    new_game.save!
    assert_equal 2, new_game.clues_right
    assert_equal 1, new_game.clues_wrong
  end

  test 'default order should be most-recently-played first' do
    assert_equal games(:most_recent), Game.first
  end
end
