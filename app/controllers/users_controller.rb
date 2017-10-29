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
    set_date_filters
    set_stats_vars
  end

  def sample
    @user = ENV['SAMPLE_USER'] ? User.find(ENV['SAMPLE_USER']) : User.first
    @email = ENV['SAMPLE_USER_EMAIL'] || @user.email
    @sample = true

    set_play_types
    set_date_filters
    set_stats_vars
    render 'show'
  end

  def update_user_filters
    @user = current_user
    new_types = params[:play_types]
    render json: {}, status: 400 and return unless new_types.is_a? Array

    new_types.select! { |type| VALID_TYPE_INPUTS.include?(type) }

    if @user.update(params.permit(*DATE_FILTER_FIELDS, play_types: []))
      render json: { success: true }
    else
      render json: @user.errors, status: 500
    end
  end

  private

  def set_play_types
    @play_types = if params[:play_types] == 'all'
                    PLAY_TYPES.keys
                  elsif params[:play_types]
                    params[:play_types].split(',')
                  elsif !@sample
                    current_user.play_types
                  else
                    ['regular']
                  end.select { |type| VALID_TYPE_INPUTS.include?(type) }
  end

  def set_date_filters
    @date_filters = if date_filters_from_params.values.any? || @sample
                      date_filters_from_params
                    else
                      current_user.date_filter_preferences
                    end
  end

  def date_filters_from_params
    return @dffp if @dffp
    @dffp = Hash[DATE_FILTER_FIELDS.map { |field| [field, params[field]] }]
    sanitize_dates
    @dffp
  end

  def sanitize_dates
    [:show_date_beginning, :show_date_from, :show_date_to,
     :date_played_beginning, :date_played_from, :date_played_to].each do |field|
      next if @dffp[field].nil? || @dffp[field].empty?
      begin
        @dffp[field] = Date.parse(@dffp[field]).strftime('%F')
      rescue ArgumentError
        @dffp[field] = nil
      end
    end
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
end
