class CalendarController < ApplicationController
  before_filter :set_wubook, :fetch_rooms

  def index
    params[:room_id].nil? ? room_id = @wba.rooms.first.room_id : room_id = params[:room_id]

    @selected_room = @wba.rooms.find_by(room_id: room_id)
    @room_prices = @wba.room_prices([room_id.to_i]).map{|key, value| value}[0]
  end

  private

  def set_wubook
    @wba = current_user.wubook_auth.first
  end

  def fetch_rooms
    unless @wba.rooms.count > 0
      @wba.create_rooms
      redirect_to calendar_index_path
    end
  end
end
