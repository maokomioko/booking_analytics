class Block < ActiveRecord::Base
  belongs_to :block_availability
  has_many :incremental_prices

  def min_price
    incremental_prices.minimum(:price)
  end
end
