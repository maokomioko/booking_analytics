class ReservationsController < ApplicationController
  helper Overbooking::ReservationsHelper

  before_action :load_hotel
  #before_action :load_channel_manager

  def index
    @room_types = @hotel.rooms.map(&:roomtype).uniq

    # @reservations = begin
    #   @channel_manager.connector.get_reservations
    # rescue ConnectorError => e
    #   []
    # end
  end

  def search
    @hotel = current_engine_user.channel_manager.hotel

    @partner_ids = @hotel.related.where(related_hotels: { is_overbooking: true }).pluck(:booking_id)
    price = params[:price].to_f

    @blocks = Overbooking::Block
      .for_hotels(@partner_ids)
      .where("(data->>'arrival_date')::date <= ?", params[:arrival].to_date)
      .where("(data->>'departure_date')::date >= ?", params[:departure].to_date)

    # @blocks = Overbooking::Block.first(100) # for test

    @blocks = Overbooking::BlockExtractor.new(@blocks).divide_by_money_and_occupancy(price, params[:occupancy].to_i)
  end

  protected

  def load_channel_manager
    @channel_manager = current_user.channel_manager
  end

  def load_hotel
    @hotel = current_user.company.hotel
  end
end
