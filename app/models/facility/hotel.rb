class Facility::Hotel < ActiveRecord::Base
  include FacilityMethods

  has_and_belongs_to_many :hotels, join_table: 'hotel_facilities_hotels', class_name: '::Hotel', foreign_key: 'hotel_facility_id', association_foreign_key: 'hotel_id'
end
