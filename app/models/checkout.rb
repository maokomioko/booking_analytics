# == Schema Information
#
# Table name: checkouts
#
#  id       :integer          not null, primary key
#  from     :string
#  to       :string
#  hotel_id :integer
#
# Indexes
#
#  index_checkouts_on_hotel_id  (hotel_id)
#

class Checkout < ActiveRecord::Base
  belongs_to :hotel
end
