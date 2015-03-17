module PriceMaker
  module HotelAmenities
    extend ActiveSupport::Concern

    included do
      def amenities_calc
        if related_ids.blank?
          hw_pool = PriceMaker::HotelWorker.pool(size: 8)
          n = 2**validate_amenities.size - 1

          results = n.times.map do |i|
            begin
              hw_pool.future.amenities_mix(id, class_fallback, review_score.to_i, i + 1)
            rescue Celluloid::DeadActorError
            end
          end

          unless results.blank? && !results[0].nil?
            self.related_ids = results.map(&:value).flatten.uniq.compact
          end

          hw_pool.terminate
        end
        related_ids
      end

      def validate_amenities
        base_facilities = Hotel.base_facilities_cache.ids

        [].tap do |arr|
          facilities.ids.each do |fid|
            arr << fid if base_facilities.include? fid
          end
        end
      end
    end
  end
end