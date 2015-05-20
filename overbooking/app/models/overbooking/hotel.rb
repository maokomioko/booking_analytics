module Overbooking
  class Hotel < ActiveRecord::Base
    self.table_name = :hotels

    has_and_belongs_to_many :related,
                            class_name: 'Overbooking::Hotel',
                            join_table: 'related_hotels',
                            foreign_key: 'hotel_id',
                            association_foreign_key: 'related_id'

    scope :full_text_search, -> (query) {
      return none if query.empty? || query.length < 3

      query = Overbooking::Hotel.prepare_fts_query(query)
      fields = %w(name booking_id address).join(', ')
      where("to_tsvector(concat_ws(' ', #{ fields }, array_to_string(district, ' '))) @@ to_tsquery(?)", query)
    }

    def self.prepare_fts_query(query)
      query = query.split(' ')
      query[query.length - 1] += ':*'
      query.join(' & ')
    end
  end
end