class Block
  include MongoWrapper

  embedded_in :block_availability
  embeds_many :incremental_price

  field :name, type: String
end

class IncrementalPrice
  include MongoWrapper

  embedded_in :block

  field :currency, type: String
  field :price, type: Float
end

#       "breakfast_included" : "0",
#       "name" : "Economy Attic Double Room",
#       "photos" : "",
#       "max_occupancy" : "2",
#       "rack_rate" : {
#         "currency" : "EUR",
#         "price" : "0.00"
#       },
#       "block_id" : "7771716_82576037_0_0",
#       "incremental_price" : [
#         {
#           "currency" : "EUR",
#           "price" : "55.00"
#         }
#       ],
#       "block_text" : "",
#       "deposit_required" : 0,
#       "min_price" : {
#         "currency" : "EUR",
#         "price" : "55.00"
#       },
#       "refundable" : "1",
#       "refundable_until" : "2015-01-10 23:59:59 +0100"
