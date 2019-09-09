class UsersController < ApplicationController
  before_action :logged_in_user,
                only: %i[update_user_filters update_sharing_status]

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

  def update_sharing_status
    @user = current_user
    if params[:user][:shared_stats_name].blank?
      params[:user][:shared_stats_name] = nil
    end

    respond_to do |format|
      if @user.update(sharing_params)
        format.js { render 'users/update_sharing_status' }
      else
        format.js { render 'users/update_sharing_error',
                    status: @user.errors.any? ? :conflict : :bad_request }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def sharing_params
    params.require(:user).permit(:shared_stats_name, :share_detailed_stats)
  end
end
