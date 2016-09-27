class GamesController < ApplicationController
  before_action :logged_in_user, except: [:game, :check]
  before_action :parse_show_date, only: [:destroy, :json]
  before_action :find_game, only: [:destroy]
  before_action :find_or_create_game, only: [:save]

  def game
    @date = Date.parse(params[:d])
    @existing_game = current_user &&
                     current_user.existing_game_date?(@date)
  rescue ArgumentError, TypeError
    # TypeError will be thrown if no date is given.
    # ArgumentError will be thrown if date cannot be parsed.
    @date = nil
    @existing_game = false
  end

  def destroy
    @game.destroy
    redirect_to request.referrer || stats_url
  end

  def json
    if (game = current_user.games.find_by(show_date: @show_date))
      render json: game
    else
      render json: {}, status: 404
    end
  end

  def save
    if @game.update(game_params)
      render json: { ids: category_ids(@game) }
    else
      render json: @game.errors, status: 409
    end
  end

  def redate
    old_date = Date.parse(params[:oldDate])
    new_date = Date.parse(params[:newDate])

    game = current_user.games.find_by(show_date: old_date)
    return render json: { errors: ['no_show'] }, status: 404 if game.nil?

    new_date_game = current_user.games.find_by(show_date: new_date)
    return render json: { errors: ['occupied'] }, status: 409 if new_date_game

    game.update_attribute(:show_date, new_date)
    render json: { success: true, newDate: new_date.strftime('%F') }

  rescue ArgumentError
    render json: { errors: ['bad_date'] }, status: 400
  end

  def check
    if logged_in? && Final.find(params[:final_id]).game.user == current_user
      render json: { match: true }
    else
      render json: { match: '' }
    end
  rescue ActiveRecord::RecordNotFound
    render json: { match: '' }
  end

  private

  def parse_show_date
    @show_date = Date.parse(params[:show_date])
  rescue ArgumentError
    @show_date = nil
  end

  def category_ids(game)
    game.sixths.map(&:id) + [game.final.id]
  end

  def find_game
    @game = current_user.games.find_by(show_date: @show_date)
    redirect_to request.referrer || root_url if @game.nil?
  end

  def find_or_create_game
    unless date_matches_id?
      render json: { date: ['Invalid date change'] }, status: 400
      return
    end

    show_date = Date.parse(params[:game][:show_date])
    @game = current_user.games.find_or_create_by!(show_date: show_date)
  rescue ArgumentError
    redirect_to game_url
  end

  def date_matches_id?
    final_id = params[:game][:final_attributes][:id]
    final_id.blank? ||
      Final.find(final_id).game.show_date ==
        Date.parse(params[:game][:show_date])
  end

  # rubocop:disable all
  def game_params
    params.require(:game)
          .permit(:show_date, :date_played, :play_type, :round_one_score,
                  :round_two_score, :final_result,
                  { sixths_attributes: [:type, :board_position, :title,
                                        :result1, :result2, :result3, :result4,
                                        :result5, :topics_string, :id] },
                  { final_attributes: [:category_title, :result, :third_right,
                                       :second_right, :first_right,
                                       :topics_string, :id] })
  end
  # rubocop:enable all
end
