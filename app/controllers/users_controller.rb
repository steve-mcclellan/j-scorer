class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :topics, :by_row]
  before_action :set_sample_data,
                only: [:sample, :sample_topics, :sample_by_row]
  before_action :set_play_types, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Signup successful. Welcome!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @user = current_user
  end

  def topics
    @user = current_user
    @user_stats = @user.multi_game_summary.stats
    render layout: false
  end

  def by_row
    @user = current_user
    @stats = @user.results_by_row(@play_types).stats
    render layout: false
  end

  def sample
    render 'show'
  end

  def sample_topics
    @user_stats = @user.multi_game_summary.stats
    render 'topics', layout: false
  end

  def sample_by_row
    @stats = @user.results_by_row(@play_types).stats
    render 'by_row', layout: false
  end

  private

  def set_play_types
    @play_types = if params[:types] == 'all'
                    PLAY_TYPES.keys
                  elsif params[:types]
                    params[:types].split(',')
                  else
                    ['regular']
                  end
  end

  def set_sample_data
    @user = ENV['SAMPLE_USER'] ? User.find(ENV['SAMPLE_USER']) : User.first
    @email = ENV['SAMPLE_USER_EMAIL'] || @user.email
    @sample = true
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
