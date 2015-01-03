class Hotel
  include MongoWrapper
  include ParamSelectable

  scope :contains_facilities, -> (keywords){ self.in(facilities: keywords) }
  scope :with_facilities, -> (keywords){ all_in(facilities: keywords) }

  scope :with_stars, -> (rate){ where(exact_class: rate) }
  scope :with_score_gt, -> (score){ self.gt(review_score: score) }
  scope :with_score_lt, -> (score){ self.lt(review_score: score) }
  scope :property_type, -> (type_id){ where(hoteltype_id: type_id) }

  has_many :rooms, foreign_key: :hotel_id
  has_many :block_availabilities

  embeds_one :location
  embeds_one :checkin
  embeds_one :checkout

  field :hotel_id, type: String
  field :_id, type: String, default: -> { hotel_id.to_s.parameterize }
  index({ hotel_id: 1 }, { background: true })

  field :name
  field :hoteltype_id

  field :city
  field :city_id
  field :address
  field :url

  field :facilities, type: Array

  field :exact_class, type: Float
  field :review_score, type: Float

  field :district
  field :zip

  def amenities_calc(hotel_ids = nil)
    n = 2**validate_amenities.size - 1
    results = n.times.pmap do |i|
      HotelWorker.new(hotel_id, hotel_ids, i).amenities_mix
    end

    begin
      results.flatten!.uniq!.reject(&:blank?)
    rescue
      puts "No results"
    end
  end

  def validate_amenities
    arr = []

    facilities.each do |f|
     arr << f if Hotel.base_facilities.include? f
    end

    arr
  end

  class << self
    def remap_with_ids
      arr = []

      Hotel.each do |hotel|
        arr << hotel.hotel_id
      end

      arr.each do |arr_el|
        hotel = Hotel.find_by(hotel_id: arr_el)
        up_hotel = Hotel.new({
          hotel_id: hotel.hotel_id,
          name: hotel.name,
          hoteltype_id: hotel.hoteltype_id,
          city: hotel.city,
          city_id: hotel.city_id,
          address: hotel.address,
          url: hotel.url,
          facilities: hotel.facilities,
          exact_class: hotel.exact_class,
          review_score: hotel.review_score,
          district: hotel.district,
          zip: hotel.zip
        })
        up_hotel.save!

        unless hotel.location.nil?
          location = Location.new
          location.latitude = hotel.location.latitude
          location.longitude = hotel.location.longitude
          up_hotel.location = location
        end

        hotel.destroy!
      end
    end
  end
end

class Location
  include MongoWrapper
  embedded_in :hotel

  field :latitude
  field :longitude
end

class Checkin
  include MongoWrapper
  embedded_in :hotel

  field :to
  field :from
end

class Checkout
  include MongoWrapper
  embedded_in :hotel
  field :to
  field :from
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
