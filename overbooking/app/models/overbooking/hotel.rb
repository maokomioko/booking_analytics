module Overbooking
  class Hotel < ActiveRecord::Base
    self.table_name = :hotels

    has_many :related_hotels
    has_many :related,
             through: :related_hotels,
             class_name: 'Overbooking::Hotel'

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