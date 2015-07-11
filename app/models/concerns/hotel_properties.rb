module HotelProperties
  extend ActiveSupport::Concern

  BASE_FACILITIES = [
    'Wi-Fi',
    'Parking',
    'Airport Shuttle (surcharge)', 'Airport Shuttle (free)',
    'Fitness Center',
    'Non-smoking Rooms',
    'Indoor Pool',
    'Spa',
    'Family Rooms',
    'Outdoor Pool',
    'Pet Friendly',
    'Facilities for Disabled Guests',
    'Restaurant'
  ]

  NEW_PROPERTY_TYPES = {
    'hotel' => 204, 'hostel' => 203, 'motel' => 205, 'apartment' => 201, 'guesthouse' => 216,
    'bed_breakfast' => 208, 'homestay' => 202, 'boat' => 215
  }

  OLD_PROPERTY_TYPES = {
    'apartment' => 2, 'guesthouse' => 3, 'hostel' => 13, 'motel' => 19, 'hotel' => 14,
    'resort' => 21, 'homestay' => 23, 'bed_breakfast' => 24, 'ryokan' => 25
  }

  included do
    scope :with_property_type, -> (type_id) { where(hoteltype_id: type_id) }

    def hoteltype
      OLD_PROPERTY_TYPES.invert[hoteltype_id.to_i]
    end
  end

  module ClassMethods
    def by_property_type(type)
      if type.to_i > 0
        return with_property_type(type)
      else
        res = with_property_type(OLD_PROPERTY_TYPES[type])
        res = with_property_type(NEW_PROPERTY_TYPES[type]) if res.nil?
      end

      res
    end

    def base_facilities
      Facility::Hotel.where(name: BASE_FACILITIES)
    end

    def base_facilities_cache
      Rails.cache.fetch(Facility::Hotel::BASE_FACILITY_CACHE_KEY) do
        base_facilities.load
      end
    end
  end
end

# NEW IDS
# 201 Apartment
# 202 Guest accommodation
# 203 Hostel
# 204 Hotel
# 205 Motel
# 206 Resort
# 207 Residence
# 208 Bed and Breakfast
# 209 Ryokan
# 210 Farm stay
# 211 Bungalow
# 212 Holiday park
# 213 Villa
# 214 Campsite
# 215 Boat
# 216 Guest house
# 218 Inn
# 219 Aparthotel
# 220 Holiday home
# 221 Lodge
# 222 Family stay
# 223 Country house
# 224 Luxury tent
# 225 Capsule hotel
# 226 Love hotel
# 227 Riad
# 228 Chalet
# 217 Uncertain

# "Parking",
# "Private Parking",
# "WiFi Available in All Areas",
# "Internet",
# "Wi-Fi",
# "Free Wi-Fi",
# "Grocery Deliveries",
# "Bicycle Rental",
# "Airport Shuttle (surcharge)",
# "Shared Lounge/TV Area",
# "Laundry",
# "Family Rooms",
# "Honeymoon Suite",
# "Heating",
# "Free Parking",
# "Car Rental",
# "Shuttle Service (surcharge)",
# "Elevator",
# "Pet Friendly",
# "On-site Parking",
# "Misc Parking",
# "Tour Desk",
# "Baggage Storage",
# "Grounds",
# "Terrace",
# "Fax/Photocopying",
# "Non-smoking Rooms",
# "Air Conditioning",
# "Designated Smoking Area",
# "All Spaces Non-Smoking (public and private)",
# "Bar",
# "Restaurant",
# "Room Service",
# "Breakfast in the Room",
# "Packed Lunches",
# "Restaurant with Dining Menu",
# "Safe",
# "Ticket Service",
# "ATM on site",
# "Concierge Service",
# "Dry Cleaning",
# "Ironing Service",
# "24-Hour Front Desk",
# "Meeting/Banquet Facilities",
# "Facilities for Disabled Guests",
# "Pool Table",
# "Sauna",
# "Spa",
# "Indoor Pool",
# "Shoeshine",
# "Soundproof Rooms",
# "Vending Machine (drinks)",
# "Vending Machine (snacks)",
# "Shared Kitchen",
# "Business Center",
# "Shops (on site)",
# "Golf Course (within 2 miles)",
# "Currency Exchange",
# "Game Room",
# "Souvenir/Gift Shop",
# "Buffet-Style Restaurant",
# "Special Diet Meals (upon request)",
# "Playground",
# "Hiking",
# "Cycling",
# "BBQ Facilities",
# "Newspapers",
# "Babysitting/Child Services",
# "Casino",
# "Snack Bar",
# "Fitness Center",
# "Massage",
# "Express Check-in/Check-out",
# "Valet Parking",
# "VIP Room Facilities",
# "Hypoallergenic room available",
# "Solarium",
# "Hot Tub",
# "Lockers",
# "Sun Deck",
# "Hair/Beauty Salon",
# "Bowling",
# "Racquetball",
# "Suit Press",
# "Library",
# "Entertainment Staff",
# "Adults Only",
# "Outdoor Pool (seasonal)",
# "Private Check-in/Check-out",
# "Convenience Store (on site)",
# "Tennis Court",
# "Ping-Pong",
# "Daily Housekeeping",
# "Darts",
# "Skiing",
# "Nightclub/DJ",
# "Indoor Pool (all year)",
# "Chapel/Shrine",
# "Mini Golf",
# "Outdoor Pool",
# "Shuttle Service (free)",
# "Kids' Club",
# "Turkish/Steam Bath",
# "Water Park",
# "Evening Entertainment",
# "Ski Storage",
# "Water Sports Facilities (on site)",
# "Bikes Available (free)",
# "Airport Shuttle (free)",
# "Fishing",
# "Horseback Riding",
# "Canoeing",
# "Karaoke",
# "Continental Breakfast",
# "Ski Passes Available"
