class CalendarController < ApplicationController
  before_filter :set_hotel_and_room

  def index
    unless current_user.company.wb_auth?
      redirect_to new_channel_manager_path
    else
      set_channel_manager
    end
  end

  def demo
    render 'index'
  end

  private

  def set_hotel_and_room
    @hotel = Hotel.includes(:rooms).find(1720)

    @room = if params[:room_id].nil?
              @hotel.rooms.first
            else
              @hotel.rooms.find(params[:room_id])
            end
  end

  def set_channel_manager
    @channel_manager = current_user.channel_managers.first

    @channel_manager.create_rooms unless @channel_manager.rooms.size > 0
    @channel_manager.rooms.each do |room|
      @channel_manager.setup_room_prices(room.room_id, room.id) unless room.room_prices.size > 0
    end
  end
end
