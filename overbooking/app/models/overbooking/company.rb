module Overbooking
  class Company < ActiveRecord::Base
    self.table_name = :companies

    has_one :channel_manager
    has_many :hotels, through: :channel_manager

    belongs_to :owner, class_name: 'Overbooking::User'
  end
end
