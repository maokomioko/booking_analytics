class WubookAuth < ActiveRecord::Base
  belongs_to :user
  belongs_to :hotel, foreign_key: :booking_id
  has_and_belongs_to_many :rooms

  validates :login, :password, :lcode, :booking_id, :hotel_name, :non_refundable_pid, :default_pid, presence: true
  validate :hotel_existence

  before_create :setup_tarif_plans

  def non_refundable_candidate
    connector.get_plans[0]['name']
  end

  def standart_rate_candidate
    connector.get_plans[1]['name']
  end

  def setup_tarif_plans
    update_attributes(non_refundable_pid: non_refundable_candidate, default_pid: standart_rate_candidate)
  end

  def create_rooms
    rooms_data = connector.get_rooms
    rooms_data.each do |rd|
      if [0, nil, ''].include? rd['subroom']
        room = rooms.new

        %w(id name price max_people subroom children occupancy availability).each do |field|
          room.send(field + '=', rd[field])
        end

        room.save
      end
    end
  end

  def setup_room_prices(room_id, room_obj_id)
    price_array = connector.get_plan_prices(non_refundable_pid, [room_id]).map{|key, value| value}[0]
    price_array.each_with_index do |price, i|
      RoomPrice.create(
        room_id: room_obj_id,
        date: Date.today + i.days,
        default_price: price
      )
    end
  end

  def apply_room_prices(room_id, dates, custom_price = nil)
    room = Room.find(room_id)

    if dates.size > 1
      price_blocks = room.room_prices.within_dates(dates)
    else
      price_blocks = room.room_prices.where(date: dates[0])
    end

    if ['', nil].include? custom_price
      new_prices = price_blocks.map(&:price)
      price_blocks.each do |block|
        block.update_attribute(:default_price, block.price)
      end
    else
      new_prices = [custom_price]
      price_blocks.update_all(default_price: custom_price, locked: true)
    end

    price_blocks.map(&:date).each do |date|
      connector.set_plan_prices(non_refundable_pid, room_id, date, new_prices)
    end

    price_blocks.update_all(enabled: true)
  end

  def connector
    WubookConnector.new({login: login, password: password, lcode: lcode})
  end

  def hotel_existence
    unless Hotel.find(booking_id).present?
      errors.add(:booking_id, I18n.t('errors.booking_id'))
    end
  end
end
