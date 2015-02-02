class PriceMaker
  include Celluloid

  HOTELS_PER_PAGE = 15

  attr_reader :get_top_prices, :min_price_listing

  def initialize(hotel_ids, occupancy, arrival, departure)
    @hotel_ids = hotel_ids
    @occupancy = occupancy

    @arrival = arrival.strftime("%Y-%m-%d")
    @departure = departure.strftime("%Y-%m-%d")

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

    prices
  end

  def split_chunks
    @chunks = @price_blocks.each_slice(HOTELS_PER_PAGE).to_a
  end

  def min_price_listing

    aw_pool = AvailabilityWorker.pool(size: 8)
    h_slices = @hotel_ids.to_a.each_slice(30)

    # Filtered blocks for hotels
    blocks = 2.times.map do
      begin
        not_blank = h_slices.next.reject(&:blank?)
        aw_pool.future.get_blocks(not_blank, @occupancy, @arrival, @departure)
      rescue DeadActorError, MailboxError
      end
    end

    blocks = blocks.map(&:value).flatten!

    pr_pool = AvailabilityWorker.pool(size: 8)
    b_slices = blocks.each_slice(30)

    # Ordered prices
    pr_blocks = b_slices.count.times.map do
      begin
        pr_pool.future.get_prices(b_slices.next)
      rescue DeadActorError, MailboxError
      end
    end

    begin
      pr_blocks = pr_blocks.map(&:value).flatten!.uniq!
      @price_blocks = pr_blocks
    rescue
      nil
    end
  end
end
