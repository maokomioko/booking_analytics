module Overbooking
  class ChannelManager < ActiveRecord::Base
    self.table_name = :channel_managers

    belongs_to :company
    belongs_to :hotel, foreign_key: :booking_id, primary_key: :booking_id
  end
end