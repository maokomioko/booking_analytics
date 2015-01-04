class HotelWorker
  include Celluloid
  include Celluloid::IO

  attr_reader :amenities_mix

  def initialize
  end

  def amenities_mix(hotel_id, hotel_ids, c_width)
    ids = []
    options = Hotel.find(hotel_id).validate_amenities.combination(c_width)

    1.upto(options.count) do
      next_set = options.next.join(', ')
      unless hotel_ids
        hotels = Hotel.with_facilities(next_set)
      else
        hotels = Hotel.where(:id.in => hotel_ids).with_facilities(next_set)
      end
      ids << hotels.map(&:hotel_id)
    end

    ids.flatten!.uniq! unless ids.nil?
  end
end
