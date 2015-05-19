require 'cancancan'
require 'kaminari'
require 'haml-rails'

require "overbooking/engine"

module Overbooking
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  def self.setup
    yield self
  end
end
