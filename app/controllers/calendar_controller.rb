class CalendarController < ApplicationController
  def index
    @months = [Date.today, Date.today + 1.month, Date.today + 2.month, Date.today + 3.month]

    wba = current_user.wubook_auth.first
    params[:room_id].nil? ? room_id = wba.rooms.first.room_id : room_id = params[:room_id]

    @room_prices = wba.room_prices([room_id.to_i]).map{|key, value| value}[0]

  end
end
