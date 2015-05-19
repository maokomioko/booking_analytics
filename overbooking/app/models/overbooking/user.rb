module Overbooking
  class User < ActiveRecord::Base
    self.table_name = :users

    has_many :hotels, through: :channel_managers
    has_many :channel_managers, through: :company

    belongs_to :company
  end
end