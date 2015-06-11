module Overbooking
  class RelatedHotel < ActiveRecord::Base
    self.table_name = :related_hotels

    belongs_to :hotel, class_name: 'Overbooking::Hotel'
    belongs_to :related,
               foreign_key: :related_id,
               class_name: 'Overbooking::Hotel'
  end
end