require 'test_helper'

class RoundTwoCategoryTest < ActiveSupport::TestCase
  def setup
    @r2cat = RoundTwoCategory.create!(game: games(:debut),
                                      board_position: 6,
                                      title: 'Before & After',
                                      result1: 1,
                                      result2: 1,
                                      result3: 1,
                                      result4: 1,
                                      result5: 1)
  end

  test 'should be valid' do
    assert @r2cat.valid?
  end

  test 'should require a game_id' do
    @r2cat.game_id = nil
    assert_not @r2cat.valid?
  end

  test 'should require a board position' do
    @r2cat.board_position = nil
    assert_not @r2cat.valid?
    @r2cat.board_position = -3
    assert_not @r2cat.valid?
    @r2cat.board_position = 0
    assert_not @r2cat.valid?
    @r2cat.board_position = 7
    assert_not @r2cat.valid?
  end

  test 'board position should be unique per game' do
    cat2 = RoundTwoCategory.new(game: games(:two),
                                board_position: 6,
                                title: 'Americana',
                                result1: 1,
                                result2: 1,
                                result3: 1,
                                result4: 1,
                                result5: 1)
    assert cat2.valid?
    cat2.game = games(:debut)
    assert_not cat2.valid?
  end
end
