# == Schema Information
#
# Table name: active_block_availabilities
#
#  id            :integer          not null, primary key
#  data          :jsonb
#  booking_id    :integer
#  max_occupancy :text             is an Array
#  fetch_stamp   :integer
#
# Indexes
#
#  index_active_block_availabilities_on_booking_id  (booking_id)
#

class BlockAvailability < ActiveRecord::Base
  self.table_name = 'active_block_availabilities'

  scope :for_hotels, -> (hotel_ids) { where("(data->>'hotel_id')::integer IN (?)", hotel_ids).order('id DESC').limit(1) }
  scope :with_occupancy, -> (occupancy) { where("jsonb2arr((data->'block'), 'max_occupancy') @> '{\"?\"}'::text[]", occupancy) }

  scope :by_arrival, -> (date) { where("(data->>'arrival_date') = ?", date.to_date.strftime('%Y-%m-%d')) }
  scope :by_departure, -> (date) { where("(data->>'departure_date') = ?", date.to_date.strftime('%Y-%m-%d')) }

  def block_prices(occupancy, room_booking_ids, price_position)
    [].tap do |arr|
      filtered_blocks(occupancy, room_booking_ids).each do |block|
        arr << block.fetch('incremental_price').map { |x| x['price'].to_f }.sort[price_position]
      end
      arr.reject(&:blank?)
    end
  end

  private

  def self.collection_name
    :block_availability
  end

  # 108258001_83983236_2_0 => 108258001
  def parse_room_id(block_id)
    block_id.split('_', 2).try(:first) || ''
  end

  def filtered_blocks(occupancy, room_booking_ids)
    data['block'].select do |block|
      occupancy_cond = block['max_occupancy'] == occupancy.to_s
      rooms_cond     = room_booking_ids.select { |room_id| room_id.to_s == parse_room_id(block['block_id']) }.size > 0

      occupancy_cond && rooms_cond
    end || []
  end
end
