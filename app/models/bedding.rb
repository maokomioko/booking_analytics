class Bedding < ActiveRecord::Base
  belongs_to :room
  has_many :beds
  accepts_nested_attributes_for :beds
end