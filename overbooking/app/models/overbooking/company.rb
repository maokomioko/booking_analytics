module Overbooking
  class Company < ActiveRecord::Base
    self.table_name = :companies

    has_many :channel_managers
    has_many :hotels, through: :channel_managers
  end
end