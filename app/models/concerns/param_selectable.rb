module ParamSelectable
  extend ActiveSupport::Concern

  module ClassMethods
    def by_old_property_type(type)
      case type
      when 'hotel'
        type_id = 14
      when 'hostel'
        type_id = 13
      when 'motel'
        type_id = 19
      when 'apartment'
        type_id = 2
      when 'guesthouse'
        type_id = 3
      when 'bed_breakfast'
        type_id = 24
      when 'homestay'
        type_id = 23
      end

      property_type(type_id)
    end

    def by_property_type(type)
      case type
      when 'hotel'
        type_id = 204
      when 'hostel'
        type_id = 203
      when 'motel'
        type_id = 205
      when 'apartment'
        type_id = 201
      when 'guesthouse'
        type_id = 216
      when 'bed_breakfast'
        type_id = 208
      when 'homestay'
        type_id = 202
      when 'boat'
        type_id = 215
      end

      property_type(type_id)
    end

    def base_facilities
      [
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
    end
  end
end

# OLD IDS
# 2   Apartment
# 3   Guest accommodation
# 13  Hostel
# 14  Hotel
# 19  Motel
# 21  Resort
# 23  Residence
# 24  Bed and Breakfast
# 25  Ryokan

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
