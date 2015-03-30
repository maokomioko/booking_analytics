class PriceMaker::HotelWorker
  include Celluloid

  attr_reader :amenities_mix

  def initialize
  end

  def amenities_mix(hotel_id, rating, score, properties, facility_ids)
    puts 'IDS Processing..'
    ids = []
    begin
      hotels = Hotel.with_stars(rating)

      if score.is_a?(Array)
        hotels = hotels.with_score(score)
      else
        hotels = hotels.with_score_gt(score)
      end

      hotels = hotels.by_property_type(properties) if properties.present?
      hotels = hotels.with_facilities(facility_ids)

      ids << hotels.map(&:id).reject(&:blank?) if hotels.size > 0

      ActiveRecord::Base.connection_pool.release_connection(Thread.current.object_id)
    rescue ActiveRecord::ConnectionTimeoutError
      retry
    end

    ids.flatten unless ids.blank?
  end
end
