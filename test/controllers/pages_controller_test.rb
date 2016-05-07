require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test 'should get home' do
    get :home
    assert_response :success
    assert_select 'title', 'J! Scorer'
  end

  test 'should get help' do
    get :help
    assert_response :success
    assert_select 'title', 'J! Scorer - Help'
  end

  test 'should get about' do
    get :about
    assert_response :success
    assert_select 'title', 'J! Scorer - About'
  end
end
