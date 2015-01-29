class WubookAuth
  include MongoWrapper
  #include ActiveModel::SecurePassword

  belongs_to :user
  has_many :rooms, class_name: 'Wubook::Room', dependent: :destroy

  validates :login, :password, :lcode, :booking_id, :hotel_name, presence: true
  validate :hotel_existence

  field :user_id, type: String
  index({ user_id: 1 }, { background: true })

  field :login, type: String
  field :password, type: String

  field :lcode, type: String
  field :booking_id, type: String
  field :hotel_name, type: String
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

  def fetch_room_prices(room_ids = nil)
    connector.get_room_prices(room_ids)
  end

  def create_room_prices(room_id, id)
    price_blocks = fetch_room_prices([room_id.to_i]).map{|key, value| value}[0]
    price_blocks.each_with_index do |block, i|
      RoomPrice.create(
        room_id: id,
        date: Date.today + i.days,
        default_price: block['price']
      )
    end
  end

  def apply_room_prices(room_id, dates)
    room = Wubook::Room.find_by(room_id: room_id)
    if dates.size > 1
      price_blocks = room.room_prices.within_dates(dates)
    else
      price_blocks = room.room_prices.where(date: dates[0])
    end

    prices = price_blocks.map(&:price)
    dates = price_blocks.map(&:date)

    response = connector.set_room_prices(room_id, dates, prices)
    if response == 'Ok'
      price_blocks.update_all(enabled: true)
      return true
    else
      return false
    end
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
