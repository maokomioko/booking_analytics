require 'celluloid'

class HotelWorker
  include Celluloid

  def initialize(hotel_id, hotel_ids, c_width)
    @hotel_ids = hotel_ids
    @c_width = c_width
    @hotel = Hotel.find(hotel_id)
  end

  def amenities_mix
    ids = []
    options = @hotel.validate_amenities.combination(@c_width)

    1.upto(options.count) do
      next_set = options.next.join(', ')
      unless @hotel_ids
        hotels = Hotel.with_facilities(next_set)
      else
        hotels = Hotel.where(:id.in => @hotel_ids).with_facilities(next_set)
      end
      ids << hotels.map(&:hotel_id)
    end

    ids.flatten!
    ids.uniq!
  end
end
