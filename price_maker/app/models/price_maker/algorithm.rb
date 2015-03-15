module PriceMaker
  class Algorithm
    HOTELS_PER_PAGE = 15

    attr_reader :get_top_prices, :min_price_listing

    def initialize(hotel_ids, occupancy, arrival, departure)
      @hotel_ids = hotel_ids
      @occupancy = occupancy

      @arrival = arrival.strftime("%Y-%m-%d")
      @departure = departure.strftime("%Y-%m-%d")

      @price_blocks = []
      @chunks = []

      safe_init
    end

    def safe_init
      min_price_listing
      split_chunks
    end

    def get_top_prices
      prices = []
      @chunks.first(3).each do |x|
        prices << x[0..2]
      end

      prices.sort
    end

    def split_chunks
      @chunks = @price_blocks.each_slice(HOTELS_PER_PAGE).to_a rescue []
    end

    def min_price_listing

      aw_pool = PriceMaker::AvailabilityWorker.pool(size: 4)
      h_slices = @hotel_ids.to_a.each_slice(30)

      # Filtered blocks for hotels
      blocks = h_slices.count.times.map do
        begin
          not_blank = h_slices.next.reject(&:blank?)
          aw_pool.future.get_blocks(not_blank, @occupancy, @arrival, @departure)
        rescue Celluloid::DeadActorError
        end
      end

      blocks = blocks.map(&:value).flatten
      aw_pool.terminate

      return if blocks.reject(&:blank?).empty?

      pr_pool = PriceMaker::AvailabilityWorker.pool(size: 4)
      b_slices = blocks.each_slice(30)

      # Ordered prices
      pr_blocks = b_slices.count.times.map do
        begin
          pr_pool.future.get_prices(b_slices.next)
        rescue Celluloid::DeadActorError
        end
      end

      begin
        pr_blocks = pr_blocks.map(&:value).flatten.uniq
        @price_blocks = pr_blocks
      rescue
        nil
      end

      pr_pool.terminate
    end
  end
end
