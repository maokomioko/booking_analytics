class RelatedHotelsController < ApplicationController
  before_filter :find_and_auth_resource
  skip_before_filter :wizard_completed

  def create
    @new_related = Hotel.where(booking_id: params[:id].split(','))

    @new_related.each do |related|
      @hotel.related_hotels << RelatedHotel.new(
        hotel: @hotel,
        related: related,
        added_manually: true
      )
    end

    list = @new_related.map(&:name).to_sentence
    flash[:success] = t('messages.success_add_related', list: list)

    # for render related_hotels/edit template
    @related = @hotel.related_hotels.includes(:related)
  end

  def enable
    update_overbooking(params, true)
  end

  def disable
    update_overbooking(params, false)
  end

  def destroy
    @related = Hotel.where(booking_id: params[:id])

    if @hotel.related.delete(@related)
      list = @related.map(&:name).to_sentence
      flash[:success] = t('messages.success_remove_related', list: list)
    end
  end

  def search
    @hotels = Hotel
      .full_text_search(params[:q])
      .where.not(booking_id: params[:id])
      .where.not(id: @hotel.related_ids)
      .where(city: @hotel.city)
      .limit(300)
  end

  protected

  def find_and_auth_resource
    @hotel = Hotel.accessible_by(current_ability)
                 .find_by_booking_id(params[:hotel_id])
    authorize! :update, @hotel
  end

  def update_overbooking(params, state)
    begin
      hotel_ids = Hotel.where(booking_id: params[:ids]).pluck(:id)
      @hotel.related_hotels.where(related_id: hotel_ids).update_all(is_overbooking: state)
      render json: {success: true}
      flash[:success] = t('messages.settings_updated')
    rescue Exception => e
      render json: {status: 500}
      flash[:error] = e.message
    end
  end
end
