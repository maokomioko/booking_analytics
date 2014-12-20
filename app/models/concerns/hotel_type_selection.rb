module HotelTypeSelection
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
