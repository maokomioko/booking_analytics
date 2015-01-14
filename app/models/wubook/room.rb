class Wubook::Room
  include MongoWrapper

  belongs_to :wubook_auth

  field :wubook_auth_id, type: String
  field :room_id, type: String

  index({ wubook_auth_id: 1 }, { background: true })
  index({ room_id: 1 }, { background: true })

  field :name, type: String
  field :max_people, type: Integer

  field :availability, type: Integer
  field :occupancy, type: Integer
  field :price, type: Float

  field :subroom, type: Integer
  field :children, type: Integer
end
