class CreateBackupJob < ApplicationJob
  include ActiveJob::Status

  def perform(user)
    puts "user id is #{user.id}"
    s = ActiveModelSerializers::SerializableResource.new(user, include: '**')
    filename = "/tmp/#{job_id}"
    File.open(filename, 'w') { |f| f.write s.to_json }

    DeleteBackupJob.set(wait: 10.minutes).perform_later(filename)
  end
end
