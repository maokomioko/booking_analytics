module Graph
  class Source < ActiveRecord::Base
    self.table_name = Graph.source_table

    scope :for_hotels, -> (hotel_ids) { where(booking_id: hotel_ids) }
    scope :by_arrival, Proc.new { |date|
      date = [date] unless date.is_a?(Array) || date.is_a?(Range)
      dates = date.map{ |d| d.to_date.strftime('%Y-%m-%d') }
      where("(data->>'arrival_date') IN (?)", dates)
    }

    scope :by_departure, -> (date) { where("(data->>'departure_date') = ?", date.to_date.strftime('%Y-%m-%d')) }
  end
end
