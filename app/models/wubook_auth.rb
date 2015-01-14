class WubookAuth
  include MongoWrapper
  #include ActiveModel::SecurePassword

  belongs_to :user
  has_many :rooms, class_name: 'Wubook::Room'

  validates :login, :password, :lcode, presence: true

  field :user_id, type: String
  index({ user_id: 1 }, { background: true })

  field :login, type: String
  field :password, type: String
  field :lcode, type: String

  #has_secure_password

  def create_rooms
    connector = WubookConnector.new({login: login, password: password, lcode: lcode})
    rooms_data = connector.get_rooms

    rooms_data.each do |rd|
      begin
        Wubook::Room.find(rd['id'])
      rescue
        wb_room = rooms.new

        %w(id name price max_people subroom children occupancy availability).each do |field|
          field == 'id' ? model_field = 'room_id' : model_field = field
          wb_room.send(model_field + '=', rd[field])
        end

        wb_room.save
      end
    end
  end
end
