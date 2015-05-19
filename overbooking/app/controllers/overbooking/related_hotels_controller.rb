require_dependency "overbooking/application_controller"

module Overbooking
  class RelatedHotelsController < ApplicationController
    before_filter :find_and_auth_resource, only: [:edit, :drop_related]

    skip_after_action :flash_to_headers, only: :drop_related
    append_after_action :add_flash_after_drop, only: :drop_related

    def index
      @hotels = Overbooking::Hotel.accessible_by(current_engine_ability)
      current_engine_ability.authorize! :index, Overbooking::Hotel

      if @hotels.length == 1
        redirect_to [:edit, :related_hotel, id: @hotels.first.booking_id] and return
      end
    end

    def edit
      @related = @hotel.related.page params[:page]
    end

    def drop_related
      @related = Overbooking::Hotel.where(booking_id: params[:ids])
      @hotel.related.delete(@related)
    end

    protected

    def find_and_auth_resource
      @hotel = Overbooking::Hotel.accessible_by(current_engine_ability)
                  .find_by_booking_id(params[:id])

      current_engine_ability.authorize! :update, @hotel
    end

    def add_flash_after_drop
      list = @related.map(&:name).to_sentence
      flash[:success] = t('overbooking.messages.success_remove_related', list: list)
    end
  end
end
