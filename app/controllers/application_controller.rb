class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :check_domain

  def check_domain
    if Rails.env.production? &&
       ENV['PROPER_DOMAIN'] &&
       request.host.casecmp(ENV['PROPER_DOMAIN']) != 0

      proper_url = "https://#{ENV['PROPER_DOMAIN']}#{request.fullpath}"
      redirect_to proper_url, status: 301
    end
  end

  private

  # Confirms that a user is logged in.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
