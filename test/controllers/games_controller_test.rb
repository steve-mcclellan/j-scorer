require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test 'should get game page' do
    get :new
    assert_response :success
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Game.count' do
      post :create, game: { show_date: Time.zone.today, date_played: Time.zone.now }
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Game.count' do
      delete :destroy, show_date: games(:victoria)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong user's game" do
    log_in_here(users(:dave))
    game = games(:steve)
    assert_no_difference 'Game.count' do
      delete :destroy, show_date: game.show_date
    end
    assert_redirected_to root_url
  end
end
