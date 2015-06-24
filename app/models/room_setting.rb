# == Schema Information
#
# Table name: room_settings
#
#  id         :integer          not null, primary key
#  position   :integer
#  room_id    :integer
#  setting_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class RoomSetting < ActiveRecord::Base
  belongs_to :room
  belongs_to :setting

  validates_uniqueness_of :room_id, scope: :setting_id
  validates_numericality_of :position,
    greater_than_or_equal_to: 1,
    only_integer: true,
    allow_nil: false
end
