class BackupsController < ApplicationController
  before_action :logged_in_user

  def new
    render json: current_user, include: '**'
  end
end
