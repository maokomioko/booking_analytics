class Facility::Hotel < ActiveRecord::Base
  include FacilityMethods

  has_and_belongs_to_many :hotels
end
