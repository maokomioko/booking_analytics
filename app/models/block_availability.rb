class BlockAvailability < ActiveRecord::Base
  belongs_to :hotel
  has_many :blocks

  scope :for_hotels, -> (hotel_ids){ where(hotel_id: hotel_ids) }
  scope :with_occupancy, -> (occupancy){ includes(:blocks).where(blocks: { max_occupancy: occupancy.to_s }) }
  scope :by_arrival, -> (date){ where(arrival_date: date) }
  scope :by_departure, -> (date){ where(departure_date: date) }

  class << self

    def to_date(hotel_ids, occupancy, arrival, departure)
      begin
        blocks = for_hotels(hotel_ids)

        unless occupancy.nil?
          blocks = blocks.with_occupancy(occupancy)
        end

        if departure.nil?
          blocks = blocks.by_arrival(arrival)
        else
          blocks = blocks.by_departure(departure)
        end

        blocks = blocks.to_a # for correct release DB connection

      rescue ActiveRecord::ConnectionTimeoutError
        puts 'wait for free db pool...'
        retry
      end

      ActiveRecord::Base.connection_pool.release_connection(Thread.current.object_id)

      blocks
    end

    def get_prices(blocks)
      begin
        arr = []

        blocks.each do |block_avail|
          arr << block_avail.blocks.map(&:min_price)
        end

      rescue ActiveRecord::ConnectionTimeoutError
        puts 'wait for free db pool...'
        retry
      end

      ActiveRecord::Base.connection_pool.release_connection(Thread.current.object_id)

      arr.sort
    end

  end

  private

  def self.collection_name
    :block_availability
  end
end
