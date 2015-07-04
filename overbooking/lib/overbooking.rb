require 'cancancan'
require 'kaminari'
require 'haml-rails'
require 'phony_rails'
require 'underscore-rails'
require 'gmaps4rails'
require 'google_directions'

require "overbooking/engine"

module Overbooking
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  mattr_accessor :default_mailer
  @@default_mailer = '::ActionMailer::Base'

  def self.setup
    yield self
  end
end
