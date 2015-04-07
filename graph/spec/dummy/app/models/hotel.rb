class Hotel < ActiveRecord::Base
  has_many :sources,
           class_name: 'Graph::Source',
           foreign_key: :booking_id,
           primary_key: :booking_id
end