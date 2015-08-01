# == Schema Information
#
# Table name: related_hotels
#
#  id             :integer          not null, primary key
#  hotel_id       :integer
#  related_id     :integer
#  is_overbooking :boolean          default(FALSE)
#  added_manually :boolean          default(FALSE)
#
# Indexes
#
#  index_related_hotels_on_hotel_id                 (hotel_id)
#  index_related_hotels_on_related_id_and_hotel_id  (related_id,hotel_id) UNIQUE
#

class RelatedHotel < ActiveRecord::Base
  self.table_name = :related_hotels

  belongs_to :hotel
  belongs_to :related,
             foreign_key: :related_id,
             class_name: 'Hotel'

  validates_uniqueness_of :hotel_id, scope: :related_id
end
