class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :topics]

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
    render layout: false
  end

  def sample
    @user = ENV['SAMPLE_USER'] ? User.find(ENV['SAMPLE_USER']) : User.first
    @email = ENV['SAMPLE_USER_EMAIL'] || @user.email
    @sample = true
    render 'show'
  end

  def sample_topics
    @user = ENV['SAMPLE_USER'] ? User.find(ENV['SAMPLE_USER']) : User.first
    @email = ENV['SAMPLE_USER_EMAIL'] || @user.email
    @sample = true
    render 'topics', layout: false
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
