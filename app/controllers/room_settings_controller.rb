class RoomSettingsController < ApplicationController
  def bulk_update
    @room_settings = RoomSetting.update(bulk_update_params.keys, bulk_update_params.values)
    if bulk_errors(@room_settings).present?
      flash[:alert] = bulk_errors(@room_settings)
    else
      flash[:success] = t('messages.room_updated')
    end
  end

  protected

  def bulk_update_params
    params.require(:room_settings).tap do |whitelisted|
      params[:room_settings].each do |(id, attr)|
        next unless can?(:update, RoomSetting.find(id))
        whitelisted[id] = ActionController::Parameters.new(attr).permit(:position)
      end
    end
  end

  def bulk_errors(room_settings)
    room_settings.map do |room_setting|
      next if room_setting.errors.empty?
      "<strong>#{ room_setting.room.name }</strong>: #{ room_setting.errors.full_messages.to_sentence }"
    end.compact.join('<br>')
  end
end