require_dependency "overbooking/application_controller"

module Overbooking
  class RelatedHotelsController < ApplicationController
    before_filter :find_and_auth_resource, except: :index

    skip_after_action :flash_to_headers, only: [:drop_related, :add_related]
    append_after_action :add_flash_after_drop, only: :drop_related
    append_after_action :add_flash_after_add, only: :add_related

    def index
      @hotels = Overbooking::Hotel
                    .accessible_by(current_engine_ability)
                    .page params[:page]
      current_engine_ability.authorize! :index, Overbooking::Hotel

      if @hotels.length == 1
        redirect_to [:edit, :related_hotel, id: @hotels.first.booking_id] and return
      end
    end

    def edit
      @related = @hotel
                     .related_hotels
                     .includes(:related)
                     .order('id DESC')
                     .page params[:page]
    end

    def drop_related
      @related = Overbooking::Hotel.where(booking_id: params[:ids])
      @hotel.related.delete(@related)
    end

    def add_related
      @related = Overbooking::Hotel.where(booking_id: params[:ids].split(','))
      @hotel.related << @related
    end

    def enable_overbooking
      hotel_ids = Hotel.where(booking_id: params[:ids]).pluck(:id)
      @hotel.related_hotels.where(related_id: hotel_ids).update_all(is_overbooking: true)
    end

    def disable_overbooking
      hotel_ids = Hotel.where(booking_id: params[:ids]).pluck(:id)
      @hotel.related_hotels.where(related_id: hotel_ids).update_all(is_overbooking: false)
    end

    def search
      @hotels = Overbooking::Hotel
                    .full_text_search(params[:q])
                    .where.not(booking_id: params[:id])
                    .where.not(id: @hotel.related_ids)
                    .where(city: @hotel.city)
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

    def add_flash_after_add
      list = @related.map(&:name).to_sentence
      flash[:success] = t('overbooking.messages.success_add_related', list: list)
    end
  end
end
