class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show update_user_filters]

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
    set_filters
    set_stats_vars
  end

  def sample
    @user = ENV['SAMPLE_USER'] ? User.find(ENV['SAMPLE_USER']) : User.first
    @email = ENV['SAMPLE_USER_EMAIL'] || @user.email
    @sample = true

    set_play_types
    set_filters
    set_stats_vars
    render 'show'
  end

  def update_user_filters
    @user = current_user
    new_types = params[:play_types]
    render json: {}, status: :bad_request and return unless new_types.is_a? Array

    new_types.select! { |type| VALID_TYPE_INPUTS.include?(type) }

    if @user.update(params.permit(*FILTER_FIELDS, play_types: []))
      render json: { success: true }
    else
      render json: @user.errors, status: :bad_request
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

  def set_filters
    @filters = if filters_from_params.values.any?
                 filters_from_params
               elsif @sample
                 filters_from_params.update(rerun_status: 'first')
               else
                 current_user.filter_preferences
               end
  end

  def filters_from_params
    return @ffp if @ffp
    @ffp = Hash[FILTER_FIELDS.map { |field| [field, params[field]] }]
    booleanize_verbs
    sanitize_dates
    @ffp
  end

  def booleanize_verbs
    %i[show_date_reverse date_played_reverse].each do |field|
      next if @ffp[field].blank?
      @ffp[field] = (@ffp[field] == 'true')
    end
  end

  def sanitize_dates
    %i[show_date_beginning show_date_from show_date_to
       date_played_beginning date_played_from date_played_to].each do |field|
      next if @ffp[field].blank?
      begin
        @ffp[field] = Date.parse(@ffp[field]).strftime('%F')
      rescue ArgumentError
        @ffp[field] = nil
      end
    end
  end

  def set_stats_vars
    filter_sql = User.filter_sql(@filters)
    @summary = @user.multi_game_summary(@play_types, filter_sql)
    @percentile_stats = @user.percentile_report(@play_types, filter_sql)
    @stats_by_topic = @user.topics_summary(@play_types, filter_sql)
    @stats_by_row = @user.results_by_row(@play_types, filter_sql)
    @final_stats = @user.final_stats(@play_types, filter_sql)
    @play_type_summary = @user.play_type_summary(filter_sql)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
