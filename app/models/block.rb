class Block < ActiveRecord::Base
  belongs_to :block_availability
  has_many :incremental_price
end
