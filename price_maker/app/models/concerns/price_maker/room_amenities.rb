##
## Concern for Room
##
module PriceMaker
  module RoomAmenities
    extend ActiveSupport::Concern

    included do
      def amenities_calc
        return [] unless validate_amenities

        if hotel.related_ids.blank?
          hotel.amenities_calc
        end

        Room.where(hotel_id: hotel.related_ids).contains_facilities(validate_amenities).pluck(:id)
      end

      def validate_amenities
        Room.base_facilities_cache.map(&:id) & facility_ids
      end
    end
  end
end
