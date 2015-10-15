# == Schema Information
#
# Table name: email_newsletters
#
#  id         :integer          not null, primary key
#  type       :string
#  string     :string
#  hotel_id   :string
#  integer    :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_email_newsletters_on_hotel_id  (hotel_id)
#

class EmailNewsletter < ActiveRecord::Base
  belongs_to :hotel
end
