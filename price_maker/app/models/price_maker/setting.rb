module PriceMaker
  class Setting < ActiveRecord::Base
    self.table_name = :settings

    has_many :room_settings, class_name: 'PriceMaker::RoomSetting' do
      def booking_room_hash
        each_with_object({}) do |rs, hash|
          hash[rs.booking_id] = rs
        end
      end
    end
  end
end