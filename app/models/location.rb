# == Schema Information
#
# Table name: locations
#
#  id        :integer          not null, primary key
#  latitude  :string
#  longitude :string
#  hotel_id  :integer
#
# Indexes
#
#  index_locations_on_hotel_id  (hotel_id)
#

class Location < ActiveRecord::Base
  belongs_to :hotel
end
