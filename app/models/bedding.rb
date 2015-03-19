# == Schema Information
#
# Table name: beddings
#
#  id      :integer          not null, primary key
#  room_id :integer
#

class Bedding < ActiveRecord::Base
  belongs_to :room
  has_many :beds
  accepts_nested_attributes_for :beds
end
