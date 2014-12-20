class Room
  include MongoWrapper

  belongs_to :hotel, foreign_key: :hotel_id

  field :_id,
    type: String,
    pre_processed: true,
    default: ->{ Moped::BSON::ObjectId.new.to_s }

  field :hotel_id, type: String
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
