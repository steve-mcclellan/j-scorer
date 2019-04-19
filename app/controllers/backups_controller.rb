class BackupsController < ApplicationController
  before_action :logged_in_user

  def new
    s = ActiveModelSerializers::SerializableResource.new(current_user,
                                                         include: '**')
    send_data s.to_json,
              filename: "backup#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.jscor"
  end

  def restore
    @file = params[:file]
    @data = JSON.parse(@file.read)

    params[:user] = @data
    # render plain: "done with it: #{restore_params.inspect}"

    if current_user.update(restore_params)
      flash[:success] = 'Victory!'
      redirect_to root_path
    else
      flash[:danger] = 'Failure.'
      redirect_to root_path
    end
  end

  private

  # rubocop:disable all
  def restore_params
    params.require(:user)
          .permit({ games_attributes: [:show_date,
                                       :date_played,
                                       :play_type,
                                       :rerun,
                                       :round_one_score,
                                       :round_two_score,
                                       :final_result,
                                       :dd1_result,
                                       :dd2a_result,
                                       :dd2b_result,
                                       { sixths_attributes: [:type,
                                                             :board_position,
                                                             :title,
                                                             :topics_string,
                                                             :result1,
                                                             :result2,
                                                             :result3,
                                                             :result4,
                                                             :result5] },
                                       { final_attributes: [:category_title,
                                                            :topics_string,
                                                            :result,
                                                            :third_right,
                                                            :second_right,
                                                            :first_right] }] })
  end
  # rubocop: enable all
end
