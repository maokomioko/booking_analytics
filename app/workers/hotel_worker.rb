class HotelWorker
  include Celluloid
  include Celluloid::IO

  attr_reader :amenities_mix

  def initialize
  end

  def amenities_mix(hotel_id, hotel_ids, c_width)
    puts "Processing.."
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

    puts 'IDS mapping...'
    ids.flatten!.uniq! unless ids.blank?
    puts 'DONE!'
  end
end
