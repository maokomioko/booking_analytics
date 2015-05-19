module Overbooking
  class Hotel < ActiveRecord::Base
    self.table_name = :hotels

    has_and_belongs_to_many :related,
                            class_name: 'Overbooking::Hotel',
                            join_table: 'related_hotels',
                            foreign_key: 'hotel_id',
                            association_foreign_key: 'related_id'
  end
end