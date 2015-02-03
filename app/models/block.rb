class Block
  include MongoWrapper

  embedded_in :block_availability
  embeds_many :incremental_price

  field :name
  field :max_occupancy
end

class IncrementalPrice
  include MongoWrapper

  embedded_in :block

  field :currency
  field :price, type: Float
end
