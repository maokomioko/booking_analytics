require_dependency "overbooking/application_controller"

module Overbooking
  class ReservationsController < ApplicationController
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
  end
end