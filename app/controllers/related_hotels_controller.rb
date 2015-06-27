class RelatedHotelsController < ApplicationController
  before_filter :find_and_auth_resource, except: :index

  skip_after_action :flash_to_headers, only: [:drop, :add]
  append_after_action :add_flash_after_drop, only: :drop
  append_after_action :add_flash_after_add, only: :add

  def index
    @hotels = Hotel
                  .accessible_by(current_ability)
                  .page params[:page]
    authorize! :index, Hotel

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

  def drop
    @related = Hotel.where(booking_id: params[:ids])
    @hotel.related.delete(@related)
  end

  def add
    @related = Hotel.where(booking_id: params[:ids].split(','))
    @hotel.related << @related
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
                 .find_by_booking_id(params[:id])

    authorize! :update, @hotel
  end

  def add_flash_after_drop
    list = @related.map(&:name).to_sentence
    flash[:success] = t('messages.success_remove_related', list: list)
  end

  def add_flash_after_add
    list = @related.map(&:name).to_sentence
    flash[:success] = t('messages.success_add_related', list: list)
  end
end
