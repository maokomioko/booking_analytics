##
## Concern for Hotel
##
module PriceMaker
  module HotelAmenities
    extend ActiveSupport::Concern

    included do
      # returns booking_id for related hotels
      def amenities_calc
        if related_ids.blank?
          settings  = channel_manager.company.setting
          amenities = validate_amenities

          args = [id]
          if settings.present?
            args << settings.stars
            args << settings.user_ratings
            args << settings.property_types.map { |type| Hotel::OLD_PROPERTY_TYPES[type] }
          else
            args << class_fallback
            args << review_score.to_i
            args << hoteltype_id
          end

          amenities.size.downto(1).map do |i|
            combinations = amenities.combination(i)
            hw_pool = PriceMaker::HotelWorker.pool(size: 8)

            results = combinations.each.map do |facility_ids|
              begin
                hw_pool.future.amenities_mix(*args, facility_ids)
              rescue Celluloid::DeadActorError
              end
            end

            unless results.blank? && !results[0].nil?
              self.related_ids = results.map(&:value).flatten.uniq.compact
              hw_pool.terminate
              break
            end

            hw_pool.terminate
          end
        end
        related.map(&:booking_id)
      end

      def validate_amenities
        Hotel.base_facilities_cache.map(&:id) & facility_ids
      end
    end
  end
end
