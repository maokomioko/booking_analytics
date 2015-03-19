# == Schema Information
#
# Table name: checkouts
#
#  id       :integer          not null, primary key
#  from     :string
#  to       :string
#  hotel_id :integer
#

class Checkout < ActiveRecord::Base
  belongs_to :hotel
end
