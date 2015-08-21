class SettingsController < ApplicationController
  load_and_authorize_resource

  def index
    setting = current_user.setting

    if can?(:update, setting)
      redirect_to [:edit, setting]
    else
      redirect_to root_path
    end
  end

  def edit
    @hotel = @setting.hotel
    @related_hotels = @hotel.related
    @related = @hotel.related_hotels.includes(:related)

    @channel_manager = @setting.company.channel_manager

    gon.rabl template: 'app/views/hotels/show.rabl'

    @cm_rooms = begin
      @channel_manager.connector.get_rooms.name_id_mapping
    rescue ConnectorError => e
      []
    end

    @room_settings = @setting.room_settings.room_hash
  end

  def update
    @setting.attributes = settings_params

    if request.xhr?
      # for render related_hotels/edit template
      @hotel = @setting.hotel
      @related = @hotel.related_hotels.includes(:related)
    end

    if @setting.save
      flash[:success] = I18n.t('messages.settings_updated')
      impressionist(@setting)

      force_fetch_prices_and_rooms

      redirect_to [:settings] unless request.xhr?
    else
      flash[:alert] = @setting.errors.full_messages.to_sentence
      render :edit unless request.xhr?
    end
  end

  protected

  def force_fetch_prices_and_rooms
    cm = @setting.company.channel_manager
    cm.sync_rooms
  end

  def settings_params
    params.require(:setting).permit(:crawling_frequency, stars: [],
      property_types: [], districts: [], user_ratings_range: [:from, :to]
    )
  end
end
