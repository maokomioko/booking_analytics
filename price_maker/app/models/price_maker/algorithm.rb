module PriceMaker
  class Algorithm
    HOTELS_PER_PAGE = 15

    attr_reader :get_top_prices, :price_tiers

    def initialize(hotel_room_ids, occupancy, arrival, departure)
      @hotel_room_ids = hotel_room_ids
      @occupancy      = occupancy

      @arrival = arrival.strftime("%Y-%m-%d")
      @departure = departure.strftime("%Y-%m-%d")

      @price_blocks = []
      @chunks = []

      safe_init
    end

    def safe_init
      price_tiers
      split_chunks
    end

    def get_top_prices
      prices = []
      @chunks.first(3).each do |x|
        prices << x[0..2]
      end

      prices.sort
    end

    def best_price
      prices = get_top_prices
      if prices.length > 1
        prices.second.first
      else
        prices.first.last
      end
    end

    def split_chunks
      @chunks = @price_blocks.each_slice(HOTELS_PER_PAGE).to_a rescue []
    end

    def price_tiers
      pool = PriceMaker::AvailabilityWorker.pool(size: 8)
      h_slices = @hotel_room_ids.each_slice(40) # [hotel_id, [room_id, room_id]]

      # Filtered blocks for hotels
      price_blocks = h_slices.count.times.map do
        begin
          not_blank = h_slices.next.reject(&:blank?)
          pool.future.get_block_prices(not_blank, @occupancy, @arrival, @departure)
        rescue Celluloid::DeadActorError
        end
      end

      @price_blocks = price_blocks.map(&:value).flatten.uniq.sort
      puts "GENERATED BLOCKS #{@price_blocks}"
      pool.terminate
    end
  end
end
