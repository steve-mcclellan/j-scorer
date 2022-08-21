require 'test_helper'

# Note: This needs to inherit from IntegrationTest to pull in the
#       fixture_file_upload method.
class RestoreFromBackupJobTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
    backup_file = fixture_file_upload('utoc_backup.jscor', 'application/octet-stream')
    @games = BackupsController.new.parse_file(backup_file)
  end

  test 'should succeed when given a good file' do
    log_in_here(@user)
    assert_difference '@user.games.count', 1 do
      RestoreFromBackupJob.perform_now(@user, @games)
    end
  end

  test 'will restore duplicate games' do
    log_in_here(@user)
    assert_difference '@user.games.count', 2 do
      RestoreFromBackupJob.perform_now(@user, @games)
      RestoreFromBackupJob.perform_now(@user, @games)
    end
  end
end
