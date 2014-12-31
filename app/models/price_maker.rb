class PriceMaker
  HOTELS_PER_PAGE = 15

  class << self
    def get_top_prices
      prices = []
      @chunks.first(3).each do |x|
        prices << x[0..2]
      end

      prices
    end

    def split_chunks(blocks)
      @chunks = blocks.each_slice(HOTELS_PER_PAGE).to_a
    end

    def min_price_listing(current_hotel)
      hotel_ids = BlockAvailability.blocks_for_date(arrival, departure)
      filtered_hotel_ids = Hotel.find(current_hotel).amenities_mix(hotel_ids)

      BlockAvailability.for_hotels(filtered_hotel_ids).get_prices(blocks)
    end
  end
end
