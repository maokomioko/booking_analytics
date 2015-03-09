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
              hw_pool.future.amenities_mix(hotel_id, exact_class, review_score.to_i, i)
            rescue DeadActorError
            end
          end

          unless results.blank?
            self.related_ids = results.map(&:value).flatten!.uniq!.compact
          end
        end
        related_ids
      end

      def validate_amenities
        arr = []

        facilities.each do |f|
          arr << f.id if Hotel.base_facilities.include? f
        end

        arr
      end
    end
  end
end