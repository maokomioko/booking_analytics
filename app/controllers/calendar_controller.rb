class CalendarController < ApplicationController
  before_filter :set_channel_manager

  def index
    redirect_to new_channel_manager_path and return unless current_user.company.wb_auth?

    @hotel = @channel_manager.hotel
    @room = if params[:room_id].nil?
              @hotel.rooms.first
            else
              @hotel.rooms.find(params[:room_id])
            end

    @dates = Date.today..2.month.from_now.to_date
    @prices = @room.room_prices
                  .within_dates(@dates)
                  .date_groupped
  end

  def demo
    # # Rott
    # @hotel = Hotel.includes(:rooms).find(2206)
    # @room = @hote.rooms.first
    # @dates = Date.today..2.month.from_now.to_date

    # Hilton
    @hotel = Hotel.includes(:rooms).find(1720)
    @room = @hote.rooms.find(9030)
    @dates = 2.month.ago.to_date..Date.today

    @prices = @room.room_prices
                  .within_dates(@dates)
                  .date_groupped

    render 'index'
  end

  private

  def set_channel_manager
    @channel_manager = current_user.channel_managers.first

    @channel_manager.create_rooms if @channel_manager.hotel.rooms.size.zero?
    @channel_manager.hotel.rooms.each do |room|
      room_id = room.send(@channel_manager.connector_room_id_key) || room.booking_id
      @channel_manager.setup_room_prices(room_id, room.id) unless room.room_prices.size > 0
    end
  end
end
