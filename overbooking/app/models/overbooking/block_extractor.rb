module Overbooking
  class BlockExtractor
    attr_accessor :blocks

    def initialize(blocks)
      @blocks = blocks
    end

    def hotel_hash
      @blocks.each_with_object({}) do |block, hash|
        hash[block.data['hotel_id']] = block
      end
    end
  end
end