require 'test_helper'

class RoundOneCategoryTest < ActiveSupport::TestCase
  def setup
    @r1cat = RoundOneCategory.create!(game: games(:debut),
                                      board_position: 1,
                                      title: 'Potpourri',
                                      topics_string: '',
                                      result1: 1,
                                      result2: 1,
                                      result3: 1,
                                      result4: 1,
                                      result5: 1)
  end

  test 'should be valid' do
    assert @r1cat.valid?
  end

  test 'should require a game_id' do
    @r1cat.game_id = nil
    assert_not @r1cat.valid?
  end

  test 'should require a valid board position' do
    @r1cat.board_position = nil
    assert_not @r1cat.valid?
    @r1cat.board_position = -3
    assert_not @r1cat.valid?
    @r1cat.board_position = 0
    assert_not @r1cat.valid?
    @r1cat.board_position = 7
    assert_not @r1cat.valid?
  end

  test 'board position should be unique per game' do
    cat2 = RoundOneCategory.new(game: games(:two),
                                board_position: 1,
                                title: 'Potent Potables',
                                topics_string: '',
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
