class RoomPrice
  include MongoWrapper

  belongs_to :room, class_name: 'Wubook::Room'

  field :room_id
  index({ room_id: 1 }, { background: true })

  field :date, type: Date
  field :price, type: Float
end
