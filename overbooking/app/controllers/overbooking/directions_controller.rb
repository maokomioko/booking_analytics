require_dependency "overbooking/application_controller"

module Overbooking
  class DirectionsController < ApplicationController
    before_filter :find_hotel, except: :index

    def index
      hotel = current_engine_user.hotels.first
      if hotel.present?
        redirect_to [:direction, id: hotel.booking_id] and return
      end
    end

    def show
    end

    def markers
      @hash = Overbooking::RelatedMarkerBuilder.build(@hotel.booking_id)
      render json: @hash.to_json
    end

    def notify_partner
      @partner = @hotel.related.where(booking_id: params[:partner_id]).first
      @map = params[:map]

      if @partner.present?
        Overbooking::DirectionsMailer.delay.notify_partner(
          @hotel.booking_id,
          @partner.booking_id,
          @map
        )
      end

      render nothing: true
    end

    protected

    def find_hotel
      @hotel = Overbooking::Hotel.accessible_by(current_engine_ability)
                   .find_by_booking_id(params[:id])
    end
  end
end
