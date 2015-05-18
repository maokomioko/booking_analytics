#
# Collection methods
#
class BlockAvailabilityExtractor
  attr_accessor :blocks

  def initialize(blocks)
    @blocks = blocks
  end

  # return all room's booking_ids
  # @return Array of String
  def room_ids
    [].tap do |ids|
      @blocks.each do |block|
        block.data['block'].each do |b|
          ids << self.class.parse_room_id(b['block_id'])
        end
      end
    end.uniq
  end

  # get one newest block_availability per hotel
  # @return Array of BlockAvailability
  def latest_per_hotel
    @blocks.each_with_object({}) do |block, hash|
      hash[block.data['hotel_id']] ||= block
      hash[block.data['hotel_id']] = block if block.id > hash[block.data['hotel_id']].id
    end.values
  end

  # 108258001_83983236_2_0 => 108258001
  def self.parse_room_id(block_id)
    block_id.split('_', 2).try(:first) || ''
  end
end