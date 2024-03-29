##
## Concern for Room
##
module PriceMaker
  module RoomAmenities
    extend ActiveSupport::Concern

    included do
      def amenities_calc(company_id)
        amenities = get_base_facilities

        return [] unless amenities

        if hotel.related_ids.blank?
          hotel.amenities_calc(company_id)
        end

        hotel_related_ids = hotel.related_ids

        ids = []

        amenities.size.downto(1) do |i|
          amenities.combination(i).each do |facility_ids|
            ids += Room
                .where(hotel_id: hotel_related_ids)
                .with_facilities(facility_ids)
                .map(&:id)
          end

          break if ids.length > 0
        end

        ids.uniq
      end

      def get_base_facilities
        Room.base_facilities_cache.map(&:id) & facility_ids
      end
    end
  end
end
