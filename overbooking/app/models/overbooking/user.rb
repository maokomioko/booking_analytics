module Overbooking
  class User < ActiveRecord::Base
    self.table_name = :users

    has_many :hotels, through: :channel_manager
    has_one :channel_manager, through: :company

    belongs_to :company
  end
end
