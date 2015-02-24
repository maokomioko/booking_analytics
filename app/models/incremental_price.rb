class IncrementalPrice < ActiveRecord::Base
  belongs_to :block

  monetize :price_cents
end