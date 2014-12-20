class Hotel
  include MongoWrapper
  include HotelTypeSelection

  scope :with_facilities, -> (keywords){ self.in(facilities: [keywords]) }
  scope :with_stars, -> (rate){ where(class: rate) }
  scope :with_score_gt, -> (score){ self.gt(review_score: score) }
  scope :with_score_lt, -> (score){ self.lt(review_score: score) }
  scope :property_type, -> (type_id){ where(hoteltype_id: type_id) }

  belongs_to :block_availability, foreign_key: 'hotel_id'
  embeds_one :location

  has_many :rooms

  field :hotel_id, type: String
  field :_id, type: String, default: ->{ hotel_id }

  field :name, type: String
  field :hoteltype_id, type: String

  field :exact_class, type: Float
  field :review_score, type: Float

  field :district, type: String
  field :zip, type: String

  class << self

  end

  def rooms_v1
    Room.where(hotel_id: hotel_id)
  end
end

class Location
  include MongoWrapper
  embedded_in :hotel

  field :latitude, type: String
  field :longitude, type: String
end

# {
#   "_id" : ObjectId("548872bc40ab8c550e64ee34"),
#   "countrycode" : "cz",
#   "review_nr" : null,
#   "city_id" : "-553173",
#   "facilities" : [
#     "Parking",
#     "Private Parking",
#     "WiFi Available in All Areas",
#     "Internet",
#     "Wi-Fi",
#     "Free Wi-Fi",
#     "Grocery Deliveries",
#     "Bicycle Rental",
#     "Airport Shuttle (surcharge)",
#     "Shared Lounge/TV Area",
#     "Laundry",
#     "Family Rooms",
#     "Honeymoon Suite",
#     "Heating"
#   ],
#   "exact_class" : "3.0",
#   "languagecode" : "de",
#   "is_closed" : 0,
#   "nr_rooms" : "1",
#   "zip" : "110 00",
#   "minrate" : null,
#   "commission" : 0,
#   "location" : {
#     "latitude" : "50.08134367302403",
#     "longitude" : "14.422453644705229"
#   },
#   "checkout" : {
#     "to" : "12:00",
#     "from" : ""
#   },
#   "currencycode" : "EUR",
#   "ranking" : null,
#   "city" : "Prague",
#   "checkin" : {
#     "to" : "",
#     "from" : "14:00"
#   },
#   "hotel_id" : "1070485",
#   "district" : "",
#   "preferred" : "0",
#   "address" : "Palackeho 2/5",
#   "pagename" : "jungmanka",
#   "class" : "3",
#   "review_score" : 0,
#   "name" : "Jungmanka",
#   "created" : "2014-05-30 16:08:28",
#   "url" : "http://www.booking.com/hotel/cz/jungmanka.html",
#   "hoteltype_id" : "2",
#   "max_rooms_in_reservation" : "0",
#   "max_persons_in_reservation" : "0",
#   "maxrate" : null,
#   "class_is_estimated" : 0,
#   "contractchain_id" : ""
# }
