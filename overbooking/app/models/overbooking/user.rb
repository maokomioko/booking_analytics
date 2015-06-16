module Overbooking
  class User < ActiveRecord::Base
    self.table_name = :users

    has_many :hotels, through: :channel_manager, class_name: 'Overbooking::Hotel'
    has_one :channel_manager,
            through: :company,
            class_name: 'Overbooking::ChannelManager'

    belongs_to :company, class_name: 'Overbooking::Company'
  end
end
