# == Schema Information
#
# Table name: beds
#
#  id         :integer          not null, primary key
#  amount     :string
#  type       :string
#  bedding_id :integer
#

class Bed < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  belongs_to :bedding
end
