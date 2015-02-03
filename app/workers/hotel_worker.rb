class HotelWorker
  include Celluloid

  attr_reader :amenities_mix

  def initialize
  end

  def amenities_mix(hotel_id, rating, score, c_width)
    puts "IDS Processing.."
    ids = []
    options = Hotel.find(hotel_id).validate_amenities.combination(c_width)

    1.upto(options.count) do
      next_set = options.next.join(', ')
        hotels = Hotel.with_stars(rating).with_score_gt(score).with_facilities(next_set)
      ids << hotels.map(&:hotel_id).reject(&:blank?) if hotels.size > 0
    end

    ids.flatten! unless ids.blank?
  end
end
