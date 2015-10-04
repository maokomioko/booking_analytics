# == Schema Information
#
# Table name: channel_managers
#
#  id                 :integer          not null, primary key
#  login              :string
#  password           :string
#  lcode              :string
#  booking_id         :integer
#  non_refundable_pid :integer
#  default_pid        :integer
#  company_id         :integer
#  type               :string           not null
#
# Indexes
#
#  index_channel_managers_on_company_id  (company_id)
#

class ChannelManager::Empty < ChannelManager
  def connector
    EmptyConnector.new
  end

  def create_rooms
    true
  end

  def setup_room_prices(room_id, room_obj_id)
    return unless room_id.present?

    room_prices = get_room_prices(room_obj_id)

    dates = [*Date.today..Date.today + 3.month]
    dates.each do |date|
      rp = if room_prices[date].present?
        room_prices[date].last
      else
        RoomPrice.new(room_id: room_obj_id, date: date)
      end

      rp.default_price = BlockAvailability.for_room_to_date(booking_id, room_obj_id, date)
      rp.save
    end
  end

  def list_plans
    ['', '']
  end

  def apply_room_prices(room_id, dates, custom_price = nil)
    true
  end
end
