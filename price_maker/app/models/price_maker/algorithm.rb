module PriceMaker
  class Algorithm
    HOTELS_PER_PAGE = 15
    PRICE_STEP = 0.43 # 50 cents \m/

    attr_reader :get_top_prices, :price_tiers

    # @param  hotel_room_ids  [ [hotel_booking_id, [room_booking_id, room_booking_id]], [hotel_booking_id, []] ]
    def initialize(hotel_room_ids, occupancy, arrival, departure, desired_position)
      @hotel_room_ids = hotel_room_ids
      @occupancy      = occupancy

      @arrival = arrival.strftime('%Y-%m-%d')
      @departure = departure.strftime('%Y-%m-%d')

      @desired_position = desired_position || 1

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
      @chunks.each do |x|
        prices << x[0..2]
      end

      prices.sort
    end

    def best_price
      prices = get_top_prices
      page = (@desired_position - 1) / HOTELS_PER_PAGE + 1

      if prices[page - 1].present? # because array index starts from 0
        price = prices[page - 1][@desired_position - 1]

        if price.present?
          price - PRICE_STEP
        else
          prices[page - 1].last # last price from page
        end
      else
        prices.last.last # last price from last page
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
      pool.terminate
    end
  end
end
