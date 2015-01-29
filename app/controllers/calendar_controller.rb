class CalendarController < ApplicationController
  before_filter :set_wubook

  def index
    params[:room_id].nil? ? room_id = @wba.rooms.first.room_id : room_id = params[:room_id]
    @room = @wba.rooms.find_by(room_id: room_id)
  end

  private

  def set_wubook
    @wba = current_user.wubook_auth.first

    @wba.create_rooms unless @wba.rooms.size > 0
    @wba.rooms.each do |room|
      @wba.create_room_prices(room.room_id, room.id) unless room.room_prices.size > 0
    end
  end
end
