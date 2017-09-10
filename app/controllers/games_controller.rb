class GamesController < ApplicationController
  before_action :logged_in_user, except: [:game, :check]
  before_action :parse_show_date, only: [:save]
  before_action :parse_old_and_new_dates, only: [:redate]
  before_action :find_game_to_redate, only: [:redate]
  before_action :find_game_to_destroy, only: [:destroy]
  before_action :find_or_create_game_to_save, only: [:save]

  def game
    @game_id = params[:g]
    @existing_game = current_user &&
                     current_user.existing_game_id?(@game_id)
  rescue ArgumentError, TypeError
    # TypeError will be thrown if no date is given.
    # ArgumentError will be thrown if date cannot be parsed.
    @game_id = nil
    @existing_game = false
  end

  def destroy
    @game.destroy
    redirect_to request.referer || stats_url
  end

  def json
    if (game = current_user.games.find_by(game_id: params[:game_id]))
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
  rescue ActiveRecord::RecordNotFound
    # This will fire if there is a mismatch between the category IDs
    # in the request and those in @game.
    # TODO: Test this. It looks like it will require an integration test
    #       to change users mid-test.
    @game.destroy if @game.sixths.empty?
    render json: { final_id: ['No match'] }, status: 409
  end

  def redate
    @game.show_date = @new_date
    @game.game_id = nil
    @game.save!
    render json: { success: true, newDate: @new_date.strftime('%F') }
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

  def category_ids(game)
    game.sixths.map(&:id) + [game.final.id]
  end

  def parse_show_date
    @show_date = Date.parse(params[:game][:show_date])
  rescue ArgumentError
    redirect_to game_url
  end

  def parse_old_and_new_dates
    @old_date = Date.parse(params[:oldDate])
    @new_date = Date.parse(params[:newDate])
  rescue ArgumentError
    render json: { errors: ['bad_date'] }, status: 400
  end

  def find_game_to_redate
    @game = find_game_from_final_id_and_date(params[:finalID], @old_date)
    return render json: { errors: ['no_show'] }, status: 404 unless @game
  end

  def find_game_to_destroy
    @game = current_user.games.find_by(game_id: params[:game_id])
    redirect_to request.referer || root_url if @game.nil?
  end

  def find_or_create_game_to_save
    if (final_id = params[:game][:final_attributes][:id]).blank?
      @game = current_user.games.create!(show_date: @show_date)
    else
      @game = find_game_from_final_id_and_date(final_id, @show_date)
      return render json: { date: ['Invalid change'] }, status: 400 unless @game
    end
  end

  def find_game_from_final_id_and_date(final_id, show_date)
    final = Final.find_by(id: final_id)
    game = final.game if final
    unless game && game.show_date == show_date && game.user == current_user
      return nil
    end
    game
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
