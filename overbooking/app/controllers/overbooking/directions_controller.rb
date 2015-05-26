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

    protected

    def find_hotel
      @hotel = Overbooking::Hotel.accessible_by(current_engine_ability)
                   .find_by_booking_id(params[:id])
      # @hotel = Hotel.first
    end
  end
end
