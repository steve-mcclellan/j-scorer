require 'test_helper'

class BackupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
    @backup_file = fixture_file_upload('files/utoc_backup.jscor', 'application/octet-stream')
    @backup_file_2 = fixture_file_upload('files/utoc_backup.jscor', 'application/octet-stream')
    @bad_backup = fixture_file_upload('files/bad_backup.jscor', 'application/octet-stream')
  end

  test 'should redirect new when not logged in' do
    get '/backup'
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should generate backup when logged in' do
    log_in_here(@user)
    get '/backup'
    assert flash.empty?
    assert_response :success
  end

  test 'should redirect restore when not logged in' do
    post '/restore'
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'restore should fail when given a bad file' do
    log_in_here(@user)
    assert_no_difference '@user.games.count' do
      post '/restore', params: { file: @bad_backup }
      assert_not flash.empty?
      assert_redirected_to root_url
    end
  end

  test 'restore should succeed when given a good file' do
    log_in_here(@user)
    assert_difference '@user.games.count', 1 do
      post '/restore', params: { file: @backup_file }
      assert flash.empty?
      assert_redirected_to stats_url
    end
  end

  test 'restore should add duplicate games' do
    log_in_here(@user)
    assert_difference '@user.games.count', 2 do
      post '/restore', params: { file: @backup_file }
      assert flash.empty?
      assert_redirected_to stats_url
      post '/restore', params: { file: @backup_file_2 }
      assert flash.empty?
      assert_redirected_to stats_url
    end
  end
end
