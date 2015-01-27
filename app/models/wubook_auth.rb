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

  def room_prices(room_ids = nil)
    connector.get_room_prices(room_ids)
  end

  def apply_room_prices(room_id, dates)
    begin
      prices = Wubook::Room.find_by(room_id: room_id).within_dates(dates).map(&:price)
      connector.set_room_prices(room_id, dates, prices)
      return true
    rescue
      false
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
