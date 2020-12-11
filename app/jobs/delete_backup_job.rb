class DeleteBackupJob < ApplicationJob
  def perform(filename)
    File.delete(filename) if File.exist?(filename)
  end
end
