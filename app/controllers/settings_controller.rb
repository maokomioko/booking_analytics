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
    company = @setting.company
    @related = ensure_related_existence(@hotel, company)

    @channel_manager = company.channel_manager

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

    if @setting.save!
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

  def ensure_related_existence(hotel, company)
    begin
      hotel.related.map(&:name)
      hotels
    rescue
      hotel.related_ids = []
      hotel.amenities_calc(company.id, true)
    end
    hotel.related_hotels.includes(:related)
  end

  def force_fetch_prices_and_rooms
    cm = @setting.company.channel_manager
    cm.sync_rooms
  end

  def settings_params
    # HACK for select2 empty value
    %i(stars property_types districts).each do |field|
      if params[:setting][field].present?
        params[:setting][field].select!(&:present?)
      end
    end

    params[:setting][:user_ratings_range][:from] = params[:setting][:user_ratings_range][:from].to_i
    params[:setting][:user_ratings_range][:to] = params[:setting][:user_ratings_range][:to].to_i

    params.require(:setting).permit(:crawling_frequency, stars: [],
      property_types: [], districts: [], user_ratings_range: [:from, :to]
    )
  end
end
