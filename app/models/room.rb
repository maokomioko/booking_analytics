class Room
  include MongoWrapper

  scope :with_facilities, -> (keywords){ self.in(facilities: [keywords]) }

  belongs_to :hotel, foreign_key: :hotel_id
  embeds_one :bedding

  field :room_id, type: String
  field :_id, type: String, default: -> { room_id.to_s.parameterize }
  index({ room_id: 1 }, { background: true })
  field :hotel_id

  field :facilities, type: Array
  field :max_persons
  field :roomtype

  field :max_price, type: Float
  field :min_price, type: Float

  class << self
    def remap_with_ids
      arr = []

      Room.each do |room|
        arr << room.room_id
      end

      arr.each do |arr_el|
        room = Room.find_by(room_id: arr_el)
        up_room = Room.new({
          room_id: arr_el,
          facilities: room.facilities,
          max_persons: room.max_persons,
          roomtype: room.roomtype,
          max_price: room.max_price,
          min_price: room.min_price})
        up_room.save!
        unless room.bedding.nil?
          bedding = Bedding.new

          room.bedding.beds.each do |bed|
            bedding.beds << bed
          end
          up_room.bedding = bedding
          up_room.bedding.save!
        end

        room.destroy!
      end
    end
  end
end

class Bedding
  include MongoWrapper
  embedded_in :room
  embeds_many :beds

  accepts_nested_attributes_for :beds
end

class Bed
  include MongoWrapper
  embedded_in :bedding

  field :amount
  field :type
end
# #{
#   "_id" : ObjectId("54955ec240ab8c2c16f0aa73"),
#   "creditcard_required" : 2,
#   "ranking" : "0",
#   "facilities" : [
#     "Washing machine",
#     "Heating",
#     "Bathtub",
#     "Toilet",
#     "Bathroom",
#     "TV",
#     "Radio",
#     "Tea/Coffee maker",
#     "Refrigerator",
#     "Microwave",
#     "Kitchen",
#     "Stovetop"
#   ],
#   "max_persons" : "4",
#   "roomtype" : null,
#   "specification_required" : 0,
#   "hotel_id" : "1166853",
#   "bookable_indirect" : 0,
#   "bookable_direct" : 1,
#   "min_price" : "51.4286",
#   "room_id" : "116685301",
#   "smoking_requested" : 1,
#   "max_price" : "55.625",
#   "roomtype_id" : "29"
# }
