class CalendarController < ApplicationController
  before_filter :set_channel_manager

  def index
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

  private

  def set_channel_manager
    @channel_manager = current_user.channel_manager
    redirect_to new_channel_manager_path unless @channel_manager.present?
  end
end
