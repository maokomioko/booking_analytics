class WubookAuth
  include MongoWrapper
  #include ActiveModel::SecurePassword

  belongs_to :user
  has_many :rooms, class_name: 'Wubook::Room', dependent: :destroy

  validates :login, :password, :lcode, :booking_id, :hotel_name, :non_refundable_pid, :default_pid, presence: true
  validate :hotel_existence

  field :user_id, type: String
  index({ user_id: 1 }, { background: true })

  field :login, type: String
  field :password, type: String

  field :lcode, type: String
  field :booking_id, type: String
  field :hotel_name, type: String

  field :non_refundable_pid, type: Integer
  field :default_pid, type: Integer
  #has_secure_password

  def create_rooms
    rooms_data = connector.get_rooms
    rooms_data.each do |rd|
      if [0, nil, ''].include? rd['subroom']
        wb_room = rooms.new

        %w(id name price max_people subroom children occupancy availability).each do |field|
          field == 'id' ? model_field = 'room_id' : model_field = field
          wb_room.send(model_field + '=', rd[field])
        end

        wb_room.save
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
    room = Wubook::Room.find_by(room_id: room_id)

    if dates.size > 1
      price_blocks = room.room_prices.within_dates(dates)
    else
      price_blocks = room.room_prices.where(date: dates[0])
    end

    if custom_price.nil?
      new_prices = price_blocks.map(&:price)
    else
      new_prices = [custom_price]
      price_blocks.update_all(default_price: custom_price)
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
