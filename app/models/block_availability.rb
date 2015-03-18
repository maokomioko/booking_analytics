class BlockAvailability < ActiveRecord::Base
  self.table_name = 'active_block_availabilities'

  scope :for_hotels, -> (hotel_ids){ where("(data->>'hotel_id')::integer IN (?)", hotel_ids).order('id DESC').limit(1) }
  scope :with_occupancy, -> (occupancy){ where("jsonb2arr((data->'block'), 'max_occupancy') @> '{\"?\"}'::text[]", occupancy) }

  scope :by_arrival, -> (date){ where("(data->>'arrival_date') = ?", date.to_date.strftime("%Y-%m-%d")) }
  scope :by_departure, -> (date){ where("(data->>'departure_date') = ?", date.to_date.strftime("%Y-%m-%d")) }

  def block_prices(occupancy, price_position)
    blocks = data['block'].select { |block| block['max_occupancy'] == occupancy.to_s }

    arr = []
    blocks.each do |block|
      arr << block.fetch('incremental_price').map{|x| x['price'].to_f}.sort[price_position]
    end

    arr.reject(&:blank?)
  end

  private

  def self.collection_name
    :block_availability
  end
end
