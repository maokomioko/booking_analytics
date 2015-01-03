class BlockAvailability
  include MongoWrapper

  belongs_to :hotel, foreign_key: :hotel_id
  embeds_many :block

  field :departure_date
  field :arrival_date

  field :hotel_id
  index({ hotel_id: 1 }, { background: true })

  scope :for_hotels, -> (hotel_ids){ where(:hotel_id.in => hotel_ids).uniq! }
  scope :by_arrival, -> (date){ where(arrival_date: date) }
  scope :by_departure, -> (date){ where(departure_date: date) }

  class << self

    def blocks_for_date(arrival, departure)
      unless departure.nil?
        blocks = by_arrival(arrival).by_departure(departure)
      else
        blocks = by_arrival(arrival)
      end
      blocks.map(&:hotel_id)
    end

    def get_prices(blocks)
      arr = []

      blocks.each do |block_avail|
        #begin
          hotel_name = Hotel.find(block_avail.hotel_id).name
          arr << block_avail.block.collect{|x| [hotel_name, x.incremental_price[0].currency, x.incremental_price[0].price]}.sort_by(&:last)
        # rescue
        #   puts "Missing hotel: #{block_avail.hotel_id}"
        # end
      end

      arr.flatten(1).sort_by(&:last)
    end

  end

  private

  def self.collection_name
    :block_availability
  end
end

# {
#   "_id" : ObjectId("5488c35040ab8c6c4056582d"),
#   "hotel_text" : "",
#   "departure_date" : "2015-01-14",
#   "arrival_date" : "2015-01-13",
#   "hotel_id" : "77717",
#   "block" : [
#     {
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
#     },
#     {
#       "breakfast_included" : "0",
#       "name" : "Double Room with Shared Bathroom",
#       "photos" : "",
#       "max_occupancy" : "2",
#       "rack_rate" : {
#         "currency" : "EUR",
#         "price" : "0.00"
#       },
#       "block_id" : "7771703_82576037_0_0",
#       "incremental_price" : [
#         {
#           "currency" : "EUR",
#           "price" : "60.00"
#         }
#       ],
#       "block_text" : "",
#       "deposit_required" : 0,
#       "min_price" : {
#         "currency" : "EUR",
#         "price" : "60.00"
#       },
#       "refundable" : "1",
#       "refundable_until" : "2015-01-10 23:59:59 +0100"
#     },
#     {
#       "breakfast_included" : "0",
#       "name" : "Double Room - Non-refundable",
#       "photos" : "",
#       "max_occupancy" : "2",
#       "rack_rate" : {
#         "currency" : "EUR",
#         "price" : "0.00"
#       },
#       "block_id" : "7771713_80529353_0_0",
#       "incremental_price" : [
#         {
#           "currency" : "EUR",
#           "price" : "60.00"
#         },
#         {
#           "currency" : "EUR",
#           "price" : "120.00"
#         },
#         {
#           "currency" : "EUR",
#           "price" : "180.00"
#         }
#       ],
#       "block_text" : "",
#       "deposit_required" : 1,
#       "min_price" : {
#         "currency" : "EUR",
#         "price" : "60.00"
#       },
#       "refundable" : 0,
#       "refundable_until" : ""
#     },
#     {
#       "breakfast_included" : "0",
#       "name" : "Double Room",
#       "photos" : "",
#       "max_occupancy" : "2",
#       "rack_rate" : {
#         "currency" : "EUR",
#         "price" : "0.00"
#       },
#       "block_id" : "7771713_82576037_0_0",
#       "incremental_price" : [
#         {
#           "currency" : "EUR",
#           "price" : "60.00"
#         },
#         {
#           "currency" : "EUR",
#           "price" : "120.00"
#         },
#         {
#           "currency" : "EUR",
#           "price" : "180.00"
#         }
#       ],
#       "block_text" : "",
#       "deposit_required" : 0,
#       "min_price" : {
#         "currency" : "EUR",
#         "price" : "60.00"
#       },
#       "refundable" : "1",
#       "refundable_until" : "2015-01-10 23:59:59 +0100"
#     },
#     {
#       "breakfast_included" : "0",
#       "name" : "Suite - Non-refundable",
#       "photos" : "",
#       "max_occupancy" : "2",
#       "rack_rate" : {
#         "currency" : "EUR",
#         "price" : "0.00"
#       },
#       "block_id" : "7771714_80529353_0_0",
#       "incremental_price" : [
#         {
#           "currency" : "EUR",
#           "price" : "80.00"
#         }
#       ],
#       "block_text" : "",
#       "deposit_required" : 1,
#       "min_price" : {
#         "currency" : "EUR",
#         "price" : "80.00"
#       },
#       "refundable" : 0,
#       "refundable_until" : ""
#     },
#     {
#       "breakfast_included" : "0",
#       "name" : "Suite",
#       "photos" : "",
#       "max_occupancy" : "2",
#       "rack_rate" : {
#         "currency" : "EUR",
#         "price" : "0.00"
#       },
#       "block_id" : "7771714_82576037_0_0",
#       "incremental_price" : [
#         {
#           "currency" : "EUR",
#           "price" : "80.00"
#         }
#       ],
#       "block_text" : "",
#       "deposit_required" : 0,
#       "min_price" : {
#         "currency" : "EUR",
#         "price" : "80.00"
#       },
#       "refundable" : "1",
#       "refundable_until" : "2015-01-10 23:59:59 +0100"
#     },
#     {
#       "breakfast_included" : "0",
#       "name" : "Family Apartment - Non-refundable",
#       "photos" : "",
#       "max_occupancy" : "4",
#       "rack_rate" : {
#         "currency" : "EUR",
#         "price" : "0.00"
#       },
#       "block_id" : "7771715_80529353_0_0",
#       "incremental_price" : [
#         {
#           "currency" : "EUR",
#           "price" : "110.00"
#         },
#         {
#           "currency" : "EUR",
#           "price" : "220.00"
#         }
#       ],
#       "block_text" : "",
#       "deposit_required" : 1,
#       "min_price" : {
#         "currency" : "EUR",
#         "price" : "110.00"
#       },
#       "refundable" : 0,
#       "refundable_until" : ""
#     },
#     {
#       "breakfast_included" : "0",
#       "name" : "Family Apartment",
#       "photos" : "",
#       "max_occupancy" : "4",
#       "rack_rate" : {
#         "currency" : "EUR",
#         "price" : "0.00"
#       },
#       "block_id" : "7771715_82576037_0_0",
#       "incremental_price" : [
#         {
#           "currency" : "EUR",
#           "price" : "110.00"
#         },
#         {
#           "currency" : "EUR",
#           "price" : "220.00"
#         }
#       ],
#       "block_text" : "",
#       "deposit_required" : 0,
#       "min_price" : {
#         "currency" : "EUR",
#         "price" : "110.00"
#       },
#       "refundable" : "1",
#       "refundable_until" : "2015-01-10 23:59:59 +0100"
#     }
#   ]
# }
