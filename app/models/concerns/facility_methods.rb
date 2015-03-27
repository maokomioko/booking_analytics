module FacilityMethods
  extend ActiveSupport::Concern

  included do
    self.table_name = class_name.downcase + '_facilities'
    self.primary_key = 'id'
  end
end
