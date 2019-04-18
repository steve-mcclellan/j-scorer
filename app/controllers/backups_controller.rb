class BackupsController < ApplicationController
  before_action :logged_in_user

  def new
    s = ActiveModelSerializers::SerializableResource.new(current_user,
                                                         include: '**')
    send_data s.to_json,
              type: :json,
              filename: "backup#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.jscor"
  end
end
