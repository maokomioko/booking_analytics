# == Schema Information
#
# Table name: locations
#
#  id        :integer          not null, primary key
#  latitude  :string
#  longitude :string
#  hotel_id  :integer
#

class Location < ActiveRecord::Base
  belongs_to :hotel
end
