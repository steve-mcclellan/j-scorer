class GamesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def show
  end

  def create
    @game = current_user.games.build(game_params)
    if @game.save
      flash[:success] = 'Game created!'
      redirect_to stats_url
    else
      render 'pages/home'
    end
  end

  def destroy
    @game.destroy
    flash[:success] = 'Game deleted'
    redirect_to request.referrer || stats_url
  end

  private

  def game_params
    params.require(:game).permit(:show_date, :date_played)
  end

  def correct_user
    @game = current_user.games.find_by(show_date: params[:show_date])
    redirect_to root_url if @game.nil?
  end
end
