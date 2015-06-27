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
  validates :login, :password, :lcode, presence: true
  validates :non_refundable_pid, :default_pid, presence: true, on: :update

  def connector_room_id_key
    'previo_id'
  end

  def connector
    PrevioConnector.new(login: login, password: password, hotel_id: lcode)
  end

  def create_rooms
    rooms_data = connector.get_rooms
    return unless rooms_data['roomKinds'].present?

    rooms_data.rooms.each do |rd|
      room = Room.find_by_previo_id(rd['obkId']) || hotel.rooms.new

      room.name = rd['name']
      room.max_people = [rd['numOfBeds'], rd['numOfExtraBeds']].map(&:to_i).sum
      room.hotel_id = hotel.id
      room.booking_hotel_id = booking_id
      room.previo_id = rd['obkId']

      # TODO I don't know if this is correct a stub
      room.min_price = 0
      room.max_price = 0

      room.save
    end
  end

  def setup_room_prices(room_id, room_obj_id)
    return unless room_id.present?

    plans = connector.get_plan_prices(nil, [room_id])

    plans.each do |plan|
      rates = plan['ratePlan']['objectKind']['rate']
      rates = [rates] unless rates.is_a?(Array)

      default_price = rates.first['nrrPrice'] || rates.first['price']

      room_prices = RoomPrice
                        .where(room_id: room_obj_id)
                        .within_dates(Date.today..3.month.from_now.to_date)
                        .date_groupped

      (plan['from'].to_date..plan['to'].to_date).to_a.each do |date|
        next if date > 3.month.from_now.to_date

        rp = if room_prices[date].present?
               room_prices[date].last
             else
               RoomPrice.new(room_id: room_obj_id, date: date)
             end

        rp.default_price = default_price unless rp.enabled?
        rp.save
      end
    end
  end
end
