# == Schema Information
#
# Table name: channel_managers
#
#  id                 :integer          not null, primary key
#  login              :string
#  password           :string
#  lcode              :string
#  booking_id         :integer
#  hotel_name         :string
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
  def connector
    WubookConnector.new(login: login, password: password, lcode: lcode)
  end

  def non_refundable_candidate
    connector.get_plans[0]['name']
  end

  def standart_rate_candidate
    connector.get_plans[1]['name']
  end

  def create_rooms
    rooms_data = connector.get_rooms
    rooms_data.each do |rd|
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
    price_array = connector.get_plan_prices(non_refundable_pid, [room_id]).map { |_key, value| value }[0]
    price_array.each_with_index do |price, i|
      RoomPrice.create(
          room_id: room_obj_id,
          date: Date.today + i.days,
          default_price: price
      )
    end
  end
end
