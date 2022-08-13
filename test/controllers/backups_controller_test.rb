require 'test_helper'

class BackupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
    @backup_file = fixture_file_upload('utoc_backup.jscor', 'application/octet-stream')
    @bad_backup = fixture_file_upload('bad_backup.jscor', 'application/octet-stream')
  end

  test 'should redirect new when not logged in' do
    get '/backup', xhr: true
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should generate backup when logged in' do
    log_in_here(@user)
    assert_enqueued_with(job: CreateBackupJob) do
      get '/backup', xhr: true
    end
    assert flash.empty?
    assert_response :success
  end

  test 'should redirect restore when not logged in' do
    post '/restore', xhr: true
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'restore should fail when given a bad file' do
    log_in_here(@user)
    assert_no_difference '@user.games.count' do
      post '/restore', xhr: true, params: { backup_file: @bad_backup }
      assert flash.empty?
      assert_response :success
      assert_template 'backups/failed_restore'
    end
  end

  test 'restore should succeed when given a good file' do
    log_in_here(@user)
    assert_enqueued_with(job: RestoreFromBackupJob) do
      post '/restore', xhr: true, params: { backup_file: @backup_file }
    end
    assert flash.empty?
    assert_response :success
    assert_template 'backups/restore'
  end
end
