class BlockAvailability < ActiveRecord::Base
  belongs_to :hotel, foreign_key: :hotel_id
  has_many :block

  scope :for_hotels, -> (hotel_ids){ where(hotel_id: hotel_ids) }
  scope :with_occupancy, -> (occupancy){ where('block.max_occupancy' => occupancy.to_s) }
  scope :by_arrival, -> (date){ where(arrival_date: date) }
  scope :by_departure, -> (date){ where(departure_date: date) }

  class << self

    def to_date(hotel_ids, occupancy, arrival, departure)
      blocks = for_hotels(hotel_ids).with_occupancy(occupancy)

      if departure.nil?
        blocks = blocks.by_arrival(arrival)
      else
        blocks = blocks.by_departure(departure)
      end
      blocks
    end

    def get_prices(blocks)
      arr = []

      blocks.each do |block_avail|
        hotel_name = Hotel.find(block_avail.hotel_id).name
        arr << block_avail.block.collect{|x| x.incremental_price[0].price}
      end

      arr.sort
    end

  end

  private

  def self.collection_name
    :block_availability
  end
end
