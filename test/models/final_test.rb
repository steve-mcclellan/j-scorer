require 'test_helper'

class FinalTest < ActiveSupport::TestCase
  def setup
    @final = Final.create!(game: games(:debut),
                           category_title: 'Word Origins',
                           result: 1)
  end

  test 'should be valid' do
    assert @final.valid?
  end

  test 'should require a game_id' do
    @final.game_id = nil
    assert_not @final.valid?
  end

  test 'game_id should be unique' do
    final2 = Final.new(game: games(:two),
                       category_title: 'Trinidadian Amateur Ichthyologists',
                       result: 1)
    assert final2.valid?
    final2.game = games(:debut)
    assert_not final2.valid?
  end
end
