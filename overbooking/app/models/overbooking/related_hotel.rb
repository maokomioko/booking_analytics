module Overbooking
  class RelatedHotel < ActiveRecord::Base
    self.table_name = :related_hotels

    belongs_to :hotel
    belongs_to :related,
               foreign_key: :related_id,
               class_name: 'Overbooking::Hotel'
  end
end