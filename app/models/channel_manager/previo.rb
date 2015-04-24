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

class ChannelManager::Previo < ChannelManager
  def connector
    PrevioConnector.new(login: login, password: password, hotel_id: lcode)
  end

  def non_refundable_candidate
    ''
  end

  def standart_rate_candidate
    connector.get_plans[0]['priId']
  end

  def create_rooms
    rooms_data = connector.get_rooms
    return unless rooms_data['roomKinds'].present?

    rooms_data['roomKinds']['objectKind'].each do |rd|
      room = rooms.new

      room.name = rd['name']
      room.max_people = [rd['numOfBeds'], rd['numOfExtraBeds']].map(&:to_i).sum
      room.hotel_id = hotel.id
      room.booking_hotel_id = booking_id

      room.save
    end
  end
end
