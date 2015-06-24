class SettingsController < ApplicationController
  load_and_authorize_resource

  def index
    @hotels = current_user.company.hotels

    if @hotels.size == 1
      setting = @hotels[0].setting_fallback

      if can?(:update, setting)
        redirect_to [:edit, setting]
      end
    end
  end

  def edit
    @hotel = @setting.hotel
    @related_hotels = @hotel.related
    @cm_rooms = @hotel.channel_manager.connector.get_rooms.name_id_mapping
    @room_settings = @setting.room_settings.room_hash
  end

  def update
    @setting.attributes = settings_params

    if @setting.save
      flash[:success] = I18n.t('messages.settings_updated')
      impressionist(@setting)

      force_fetch_prices_and_rooms

      redirect_to [:settings] unless request.xhr?
    else
      flash[:alert] = @setting.errors.full_messages.to_sentence

      if request.xhr?
        render none: true
      else
        render :edit
      end
    end
  end

  protected

  def force_fetch_prices_and_rooms
    cm = @setting.hotel.channel_manager

    cm.sync_rooms
    cm.try(:fill_prices, @setting.id)
  end

  def settings_params
    # HACK for select2 empty value
    %i(stars property_types districts).each do |field|
      if params[:setting][field].present?
        params[:setting][field].select!(&:present?)
      end
    end

    params.require(:setting).permit(:crawling_frequency, stars: [],
      property_types: [], districts: [], user_ratings_range: [:from, :to]
    )
  end
end
