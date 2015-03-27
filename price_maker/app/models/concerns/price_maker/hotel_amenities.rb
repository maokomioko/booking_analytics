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
          settings = channel_manager.company.setting
          hw_pool = PriceMaker::HotelWorker.pool(size: 8)
          n = 2**validate_amenities.size - 1

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

          results = n.times.map do |i|
            begin
              hw_pool.future.amenities_mix(*args, i + 1)
            rescue Celluloid::DeadActorError
            end
          end

          unless results.blank? && !results[0].nil?
            self.related_ids = results.map(&:value).flatten.uniq.compact
          end

          hw_pool.terminate
        end
        related.map(&:booking_id)
      end

      def validate_amenities
        Hotel.base_facilities_cache.map(&:id) & facility_ids
      end
    end
  end
end
