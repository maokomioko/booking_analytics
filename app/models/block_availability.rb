# == Schema Information
#
# Table name: active_block_availabilities
#
#  id            :integer          not null, primary key
#  max_occupancy :string
#  data          :jsonb
#  booking_id    :integer
#  fetch_stamp   :string
#
# Indexes
#
#  index_active_block_availabilities_on_booking_id  (booking_id)
#

class BlockAvailability < ActiveRecord::Base
  self.table_name = 'active_block_availabilities'

  scope :for_hotels, -> (hotel_ids) { where("(data->>'hotel_id')::integer IN (?)", hotel_ids) }

  scope :today, -> {
    today = Date.tomorrow
    where("(data->>'arrival_date')::date <= ?", today).
    where("(data->>'departure_date')::date > ?", today)
  }
  scope :by_arrival, -> (date) { where("(data->>'arrival_date')::date = ?", date.to_date) }
  scope :by_departure, -> (date) { where("(data->>'departure_date')::date = ?", date.to_date) }
  scope :with_max_occupancy, -> (people) { where("data -> 'block' @> ?", [{max_occupancy: "#{people}"}].to_json) }

  def block_prices(occupancy, room_booking_ids, price_position)
    [].tap do |arr|
      filtered_blocks(occupancy, room_booking_ids).each do |block|
        arr << block.fetch('incremental_price').map { |x| x['price'].to_f }.sort[price_position]
      end
      arr.reject(&:blank?)
    end
  end

  class << self
    def with_min_price(from_price, to_price)
      arr = []
      all.each do |block_availability|
        block_availability.data['block'].each do |block|
          price = block['min_price']['price'].to_i

          if price >= from_price.to_i && price <= to_price.to_i
            arr << [block, block_availability.data['hotel_id']]
          end
        end
      end

      arr
    end

    def fetch_meta(blocks)
      arr = []
      blocks.each do |block|
        hotel = Hotel.find_by_booking_id(block[1])
        arr << [hotel.try(:name), hotel.try(:url), block[0]['name'], block[0]['min_price']['price']]
      end

      arr
    end
  end

  private

  def filtered_blocks(occupancy, room_booking_ids)
    data['block'].select do |block|
      occupancy_cond = block['max_occupancy'] == occupancy.to_s
      rooms_cond     = room_booking_ids.select { |room_id| room_id.to_s == BlockAvailabilityExtractor.parse_room_id(block['block_id']) }.size > 0

      occupancy_cond && rooms_cond
    end || []
  end

  def self.collection_name
    :block_availability
  end
end
