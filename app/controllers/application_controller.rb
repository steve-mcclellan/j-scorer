class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  # Suggested at stackoverflow.com/questions/6701549/heroku-ssl-on-root-domain
  before_action :check_domain

  def check_domain
    if Rails.env.production? && request.host.casecmp('j-scorer.com') != 0
      redirect_to 'https://j-scorer.com' + request.fullpath, status: 301
    end
  end
end
