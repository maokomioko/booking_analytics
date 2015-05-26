class RoomsController < ApplicationController
  load_and_authorize_resource except: :bulk_update

  def update
    unless @room.update(room_params)
      flash[:alert] = @room.errors.full_messages.to_sentence
      render none: true
    end
  end

  def bulk_update
    @rooms = Room.update(bulk_update_params.keys, bulk_update_params.values)
    if bulk_errors(@rooms).present?
      flash[:alert] = bulk_errors(@rooms)
    else
      if params[:manual] && params[:manual] == 'true'
        flash[:success] = t('messages.room_updated')
      end
    end
  end

  protected

  def allowed_attributes
    attributes = %i(max_price min_price)

    if can?(:update_connector_credentials, Room)
      attributes += %i(booking_id previo_id)
    end

    attributes
  end

  def room_params
    params.require(:room).permit(*allowed_attributes)
  end

  def bulk_update_params
    params.require(:rooms).tap do |whitelisted|
      params[:rooms].each do |(room_id, attr)|
        next unless can?(:update, Room.find(room_id))
        whitelisted[room_id] = ActionController::Parameters.new(attr)
            .permit(*allowed_attributes)
      end
    end
  end

  def bulk_errors(rooms)
    rooms.map do |room|
      next if room.errors.empty?
      "<strong>#{ room.name }</strong>: #{ room.errors.full_messages.to_sentence }"
    end.compact.join('<br>')
  end
end
