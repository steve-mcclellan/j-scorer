class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :update_user_filters]

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
    @email = @user.email
    @sample = false

    set_play_types
    set_stats_vars
  end

  def sample
    @user = ENV['SAMPLE_USER'] ? User.find(ENV['SAMPLE_USER']) : User.first
    @email = ENV['SAMPLE_USER_EMAIL'] || @user.email
    @sample = true

    set_play_types
    set_stats_vars
    render 'show'
  end

  def update_user_filters
    @user = current_user
    new_types = params[:play_types]
    render json: {}, status: 400 and return unless new_types.is_a? Array

    new_types.select! { |type| VALID_TYPE_INPUTS.include?(type) }

    if @user.update(user_filter_params)
      render json: { success: true }
    else
      render json: @user.errors, status: 500
    end
  end

  private

  def set_play_types
    @play_types = if !@sample
                    current_user.play_types
                  elsif params[:play_types] == 'all'
                    PLAY_TYPES.keys
                  elsif params[:play_types]
                    params[:play_types].split(',')
                  else
                    ['regular']
                  end.select { |type| VALID_TYPE_INPUTS.include?(type) }
  end

  def set_stats_vars
    @summary = @user.multi_game_summary(@play_types)
    @percentile_stats = @user.percentile_report(@play_types)
    @stats_by_topic = @user.topics_summary(@play_types)
    @stats_by_row = @user.results_by_row(@play_types)
    @final_stats = @user.final_stats(@play_types)
    @play_type_summary = @user.play_type_summary
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_filter_params
    params.permit(
      :show_date_reverse, :show_date_preposition, :show_date_beginning,
      :show_date_last_number, :show_date_last_unit, :show_date_from,
      :show_date_to, :show_date_weight, :show_date_half_life,
      :date_played_reverse, :date_played_preposition, :date_played_beginning,
      :date_played_last_number, :date_played_last_unit, :date_played_from,
      :date_played_to, :date_played_weight, :date_played_half_life,
      play_types: []
    )
  end
end
