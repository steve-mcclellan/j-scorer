class PagesController < ApplicationController
  def home
    @game = current_user.games.build if logged_in?
  end

  def help
  end

  def about
  end
end
