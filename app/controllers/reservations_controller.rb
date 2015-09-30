class ReservationsController < ApplicationController
  helper OverbookingHelper

  before_action :load_hotel
  #before_action :load_channel_manager

  def index
    @room_types = @hotel.rooms.map(&:roomtype).uniq
    gon.rabl template: 'app/views/hotels/show.rabl'

    # @reservations = begin
    #   @channel_manager.connector.get_reservations
    # rescue ConnectorError => e
    #   []
    # end
  end

  def search
    @occupancy = reservation_params[:max_occupancy]
    @partner_ids = @hotel.related.where(related_hotels: { is_overbooking: true }).pluck(:booking_id)
    price = params[:price].to_f

    @block_availabilities = BlockAvailability.for_hotels(@partner_ids)
      .with_max_occupancy(@occupancy)
      .by_arrival(reservation_params[:check_in])
      .by_departure(reservation_params[:check_out])
  end

  protected

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :min_price, :max_price, :room_type, :max_occupancy)
  end

  def load_channel_manager
    @channel_manager = current_user.channel_manager
  end

  def load_hotel
    @hotel = current_user.company.hotel
  end
end
