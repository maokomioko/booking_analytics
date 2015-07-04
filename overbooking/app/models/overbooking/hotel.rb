module Overbooking
  class Hotel < ActiveRecord::Base
    self.table_name = :hotels

    has_many :contacts, class_name: 'Overbooking::Contact'

    has_many :related_hotels, class_name: 'Overbooking::RelatedHotel'
    has_many :related,
             through: :related_hotels,
             class_name: 'Overbooking::Hotel'

    scope :full_text_search, -> (query) {
      return none if query.empty? || query.length < 3

      query = Overbooking::Hotel.prepare_fts_query(query)
      fields = %w(name booking_id address district).join(', ')
      where("to_tsvector(concat_ws(' ', #{ fields }))) @@ to_tsquery(?)", query)
    }

    accepts_nested_attributes_for :contacts, allow_destroy: true

    def self.prepare_fts_query(query)
      query = query.split(' ')
      query[query.length - 1] += ':*'
      query.join(' & ')
    end

    def blocks
      Overbooking::Block.where("(data->>'hotel_id')::integer = ?", booking_id)
    end
  end
end