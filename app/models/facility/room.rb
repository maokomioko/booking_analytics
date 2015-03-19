# == Schema Information
#
# Table name: room_facilities
#
#  id    :integer          not null, primary key
#  name  :string
#  count :integer          default(0)
#

class Facility::Room < ActiveRecord::Base
  include FacilityMethods

  has_and_belongs_to_many :rooms,
                          join_table: 'room_facilities_rooms',
                          class_name: '::Room',
                          foreign_key: 'room_facility_id',
                          association_foreign_key: 'room_id'
end
