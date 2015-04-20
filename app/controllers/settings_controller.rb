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
  end

  def update
    @setting.attributes = settings_params

    if @setting.save
      redirect_to [:settings], success: I18n.t('messages.settings_updated')
    else
      flash[:alert] = @setting.errors.full_messages.to_sentence
      render :edit
    end
  end

  protected

  def settings_params
    # HACK for select2 empty value
    %i(stars user_ratings property_types districts).each do |field|
      if params[:setting][field].present?
        params[:setting][field].select!(&:present?)
      end
    end

    params.require(:setting).permit(:crawling_frequency, :strategy, stars: [],
      user_ratings: [], property_types: [], districts: [])
  end
end
