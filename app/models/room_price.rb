class RoomPrice
  include MongoWrapper

  belongs_to :room, class_name: 'Wubook::Room'

  scope :within_dates, -> (dates){ where(:date.in => dates)}

  field :room_id
  index({ room_id: 1 }, { background: true })

  field :date, type: Date

  field :default_price, type: Float
  field :price, type: Float

  field :enabled, type: Boolean
  field :locked, type: Boolean
end
