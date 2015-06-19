require_dependency "overbooking/application_controller"

module Overbooking
  class PartnersController < ApplicationController
    before_filter :find_and_auth_resource, except: :index

    def index
      @hotels = Overbooking::Hotel
                    .accessible_by(current_engine_ability)
                    .page params[:page]
      current_engine_ability.authorize! :index, Overbooking::Hotel

      if @hotels.length == 1
        redirect_to [:edit, :partner, id: @hotels.first.booking_id] and return
      end
    end

    def edit
      @related = @hotel
                     .related_hotels
                     .includes(:related)
                     .order('id DESC')
                     .page params[:page]
    end

    def enable
      hotel_ids = Overbooking::Hotel.where(booking_id: params[:ids]).pluck(:id)
      @hotel.related_hotels.where(related_id: hotel_ids).update_all(is_overbooking: true)
    end

    def disable
      hotel_ids = Overbooking::Hotel.where(booking_id: params[:ids]).pluck(:id)
      @hotel.related_hotels.where(related_id: hotel_ids).update_all(is_overbooking: false)
    end

    protected

    def find_and_auth_resource
      @hotel = Overbooking::Hotel.accessible_by(current_engine_ability)
                  .find_by_booking_id(params[:id])

      current_engine_ability.authorize! :update, @hotel
    end
  end
end
