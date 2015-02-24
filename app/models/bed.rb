class Bed < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  belongs_to :bedding
end