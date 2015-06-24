module PriceMaker
  class RoomSetting < ActiveRecord::Base
    self.table_name = :room_settings

    belongs_to :setting, class_name: 'PriceMaker::Setting'
  end
end