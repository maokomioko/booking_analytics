class SettingsController < ApplicationController
  load_and_authorize_resource

  def index
    @hotels = current_user.company.hotels

    if @hotels.size == 1
      redirect_to [:edit, @hotels[0].setting_fallback]
    end
  end

  def edit
    @hotel = @setting.hotel
    @related_hotels = @hotel.related
    @cm_rooms = @hotel.channel_manager.connector.get_rooms.name_id_mapping
  end

  def update
    @setting.attributes = settings_params

    if @setting.save
      flash[:success] = I18n.t('messages.settings_updated')
      impressionist(@setting)
      @setting.hotel.channel_manager.sync_rooms
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

  def settings_params
    # HACK for select2 empty value
    %i(stars property_types districts).each do |field|
      if params[:setting][field].present?
        params[:setting][field].select!(&:present?)
      end
    end

    params.require(:setting).permit(:crawling_frequency, :strategy, stars: [],
      property_types: [], districts: [], user_ratings_range: [:from, :to]
    )
  end
end
