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

class ChannelManager::Wubook < ChannelManager
  validates :login, :password, :lcode, presence: true
  validates :non_refundable_pid, :default_pid, presence: true, on: :update

  def connector_room_id_key
    'wubook_id'
  end

  def connector
    WubookConnector.new(login: login, password: password, lcode: lcode)
  end

  def create_rooms
    rooms_data = connector.get_rooms
    rooms_data.rooms.each do |rd|
      if [0, nil, ''].include? rd['subroom']
        room = hotel.rooms.new

        %w(id name price max_people subroom children occupancy availability).each do |field|
          room.send(field + '=', rd[field])
        end

        room.save
      end
    end
  end

  def setup_room_prices(room_id, room_obj_id)
    return unless room_id.present?

    room_prices = get_room_prices(room_obj_id)

    price_array = connector.get_plan_prices(non_refundable_pid, [room_id]).map { |_key, value| value }[0]
    price_array.each_with_index do |price, i|
      date = Date.today + i.days

      rp = if room_prices[date].present?
        room_prices[date].last
      else
        RoomPrice.new(room_id: room_obj_id, date: Date.today + i.days)
      end

      rp.default_price = price
      rp.save
    end
  end
end
