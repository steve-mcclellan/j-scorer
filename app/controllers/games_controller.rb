class GamesController < ApplicationController
  before_action :logged_in_user,  only: [:create, :edit, :destroy]
  before_action :correct_user,    only: [:edit, :destroy]
  before_action :initialize_game, only: :new

  def new
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

  def edit
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

  def initialize_game
    @game = Game.new
    1.upto(6) do |i|
      @game.round_one_categories.build(board_position: i)
      @game.round_two_categories.build(board_position: i)
    end
    @game.build_final
  end
end
