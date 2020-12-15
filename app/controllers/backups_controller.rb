class BackupsController < ApplicationController
  include BackupsHelper

  before_action :dump_anonymous_user

  def new
    user = current_user
    job = CreateBackupJob.perform_later(user)
    render json: { status: 'new', job_id: job.job_id, games: user.games.count }
  end

  def status
    job_status = ActiveJob::Status.get(params[:backup_id])
    logger.info { "About to return backup job status: #{job_status}" }
    render json: job_status
  end

  def download
    timestamp = Time.zone.now.strftime('%Y%m%d%H%M%S')
    server_filename = "/tmp/#{params[:backup_id]}"
    send_file server_filename,
              filename: "backup#{timestamp}.jscor",
              type: 'application/octet-stream'
  end

  def restore
    games = parse_file(params[:backup_file])
    render 'failed_restore' and return unless games.present?

    job = RestoreFromBackupJob.perform_later(current_user, games)
    @games_count = games.count
    @job_id = job.job_id
  end

  def restore_progress
    job_status = ActiveJob::Status.get(params[:restore_id])
    logger.info { "About to return restore job status: #{job_status}" }
    render json: job_status
  end
end
