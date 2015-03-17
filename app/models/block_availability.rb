class BlockAvailability < ActiveRecord::Base
  belongs_to :hotel, foreign_key: 'booking_id'
  has_many :blocks

  scope :for_hotels, -> (hotel_ids){ where(booking_id: hotel_ids) }
  scope :with_occupancy, -> (occupancy){ includes(:blocks).where(blocks: { max_occupancy: occupancy.to_s }) }
  scope :by_arrival, -> (date){ where(arrival_date: date) }
  scope :by_departure, -> (date){ where(departure_date: date) }

  class << self

    def to_date(hotel_ids, occupancy, arrival, departure)
      begin
        blocks = for_hotels(hotel_ids)

        blocks = blocks.with_occupancy(occupancy) unless occupancy.nil?
        blocks = departure.nil? ? blocks.by_arrival(arrival) : blocks.by_departure(departure)
        blocks = blocks.to_a # correct DB connection release

      rescue ActiveRecord::ConnectionTimeoutError
        puts 'Cleaning DB Pool.. Please wait'
        retry
      end

      ActiveRecord::Base.connection_pool.release_connection(Thread.current.object_id)
      puts "#{blocks}"
      blocks
    end

    def get_prices(blocks)
      begin
        arr = []

        blocks.each do |block_avail|
          arr << block_avail.blocks.map(&:min_price)
        end

      rescue ActiveRecord::ConnectionTimeoutError
        puts 'Cleaning DB Pool.. Please wait'
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
