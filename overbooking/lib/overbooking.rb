require 'cancancan'
require 'kaminari'
require 'haml-rails'
require 'underscore-rails'
require 'gmaps4rails'
require 'google_directions'

require "overbooking/engine"

module Overbooking
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  def self.setup
    yield self
  end
end
