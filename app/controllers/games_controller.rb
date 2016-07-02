class GamesController < ApplicationController
  before_action :logged_in_user, except: [:new]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @game = Game.new
    1.upto(6) { |i| @game.round_one_categories.build(board_position: i) }
    1.upto(6) { |i| @game.round_two_categories.build(board_position: i) }
    @game.build_final
  end

  # def create
  #   @game = current_user.games.build(game_params)
  #   if @game.save
  #     flash[:success] = 'Game created!'
  #     redirect_to stats_url
  #   else
  #     redirect_to root_url
  #   end
  # end

  def edit
    # render json: @game
  end

  # def update
  #   @game = current_user.games.find_by(show_date: params[:show_date])
  #   if @game.update(game_params)
  #     redirect_to stats_url
  #   else
  #     redirect_to root_url
  #   end
  # end

  def destroy
    @game.destroy
    flash[:success] = 'Game deleted'
    redirect_to request.referrer || stats_url
  end

  def json
    game = current_user.games.find_by(show_date: params[:show_date])
    render json: game
  end

  def save
    # Horrible code for development purposes:
    render json: params.inspect
  end

  private

  def correct_user
    @game = current_user.games.find_by(show_date: params[:show_date])
    redirect_to root_url if @game.nil?
  end

  # rubocop:disable all
  def game_params
    params.require(:game)
          .permit(:show_date,
                  :date_played,
                  :play_type,
                  :id,
                  { sixths_attributes: [:type,
                                        :board_position,
                                        :title,
                                        :result1,
                                        :result2,
                                        :result3,
                                        :result4,
                                        :result5,
                                        :topics_string,
                                        :id] },
                  { final_attributes: [:category_title,
                                       :result,
                                       :contestants_right,
                                       :contestants_wrong,
                                       :topics_string,
                                       :id] })
  end
  # rubocop:enable all
end
