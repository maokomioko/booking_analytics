##
## Concern for Hotel
##
module PriceMaker
  module HotelAmenities
    extend ActiveSupport::Concern

    included do
      # returns booking_id for related hotels
      def amenities_calc(company_id = nil, force = false)
        if related_ids.blank? || force
          settings  = Company.find(company_id).setting_fallback if company_id
          amenities = get_base_facilities

          args = [id]
          if settings.present?
            args << settings.stars
            args << settings.user_ratings
            args << settings.property_types.map { |type| Hotel::OLD_PROPERTY_TYPES[type] }
            args << settings.districts
          else
            args << class_fallback
            args << review_score.to_i
            args << hoteltype_id
            args << district
          end

          amenities.size.downto(1).map do |i|
            combinations = amenities.combination(i)
            hw_pool = PriceMaker::HotelWorker.pool(size: 8)

            results = combinations.each.map do |facility_ids|
              begin
                hw_pool.future.amenities_mix(*args, facility_ids)
              rescue Celluloid::DeadActorError
              end
            end.map(&:value).flatten.uniq.compact

            unless results.blank?
              results.each do |id|
                self.related << Hotel.find(id) unless related_ids.include?(id)
              end
              hw_pool.terminate
              break
            end

            hw_pool.terminate
          end
        end
        related.map(&:booking_id)
      end

      def get_base_facilities
        Hotel.base_facilities_cache.map(&:id) & facility_ids
      end
    end
  end
end
