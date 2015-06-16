module Overbooking
  class ChannelManager < ActiveRecord::Base
    self.table_name = :channel_managers
    self.inheritance_column = :_type_disabled

    belongs_to :company, class_name: 'Overbooking::Company'
    belongs_to :hotel,
               foreign_key: :booking_id,
               primary_key: :booking_id,
               class_name: 'Overbooking::Hotel'
  end
end