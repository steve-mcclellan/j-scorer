class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :update_user_types]
  before_action :logged_in_for_json, only: [:topics, :by_row]
  before_action :set_current_user, only: [:show, :topics, :by_row,
                                          :update_user_types]

  before_action :set_sample_data,
                only: [:sample, :sample_topics, :sample_by_row]

  before_action :set_play_types, except: [:new, :create, :update_user_types]
  before_action :set_summary, only: [:show, :sample, :topics, :sample_topics]

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
    @play_type_summary = @user.play_type_summary
  end

  def topics
    @stats = @user.topics_summary(@play_types)
    render layout: false
  end

  def by_row
    @stats = @user.results_by_row(@play_types)
    render layout: false
  end

  def sample
    @play_type_summary = @user.play_type_summary
    render 'show'
  end

  def sample_topics
    @stats = @user.topics_summary(@play_types)
    render 'topics', layout: false
  end

  def sample_by_row
    @stats = @user.results_by_row(@play_types)
    render 'by_row', layout: false
  end

  def update_user_types
    new_types = params[:play_types]
    render json: {}, status: 400 and return unless new_types.is_a? Array

    new_types.select! { |type| VALID_TYPE_INPUTS.include?(type) }

    if @user.update(play_types: new_types)
      render json: { success: true }
    else
      render json: @user.errors, status: 400
    end
  end

  private

  def set_play_types
    @play_types = if params[:types] == 'all'
                    PLAY_TYPES.keys
                  elsif params[:types]
                    params[:types].split(',')
                  elsif !@sample
                    current_user.play_types
                  else
                    ['regular']
                  end.select { |type| VALID_TYPE_INPUTS.include?(type) }
  end

  def set_sample_data
    @user = ENV['SAMPLE_USER'] ? User.find(ENV['SAMPLE_USER']) : User.first
    @email = ENV['SAMPLE_USER_EMAIL'] || @user.email
    @sample = true
  end

  def set_summary
    @summary = @user.multi_game_summary(@play_types)
  end

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
