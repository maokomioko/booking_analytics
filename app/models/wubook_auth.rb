class WubookAuth
  include MongoWrapper
  include ActiveModel::SecurePassword

  belongs_to :user
  has_many :rooms, class_name: 'Wubook::Room'

  validates :login, :password, :lcode, presence: true

  field :user_id, type: String
  index({ user_id: 1 }, { background: true })

  field :login, type: String
  field :password_digest, type: String
  field :lcode, type: String

  has_secure_password

  def get_rooms
    raise "#{{login: login, password: password, lcode: lcode}}"
    connector = WubookConnector.new({login: login, password: password, lcode: lcode})
    rooms_data = connector.get_rooms

    rooms_data.each do |rd|
      puts rd
    end
  end
end
