class BackupsController < ApplicationController
  before_action :dump_anonymous_user

  def new
    s = ActiveModelSerializers::SerializableResource.new(current_user,
                                                         include: '**')
    send_data s.to_json,
              filename: "backup#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.jscor"
  end

  def restore
    data = JSON.parse(params[:file].read)

    if data.is_a? Hash
      params[:user] = data
    else
      flash[:danger] = 'Invalid file format'
      redirect_to root_path and return
    end

    if current_user.update(restore_params)
      redirect_to stats_path
    else
      flash[:danger] = 'Could not restore data'
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
