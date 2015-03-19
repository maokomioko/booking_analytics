# == Schema Information
#
# Table name: checkins
#
#  id         :integer          not null, primary key
#  name       :string
#  hotel_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Checkin < ActiveRecord::Base
  belongs_to :hotel
end
