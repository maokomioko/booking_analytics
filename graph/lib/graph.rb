require 'raphael-rails'
require 'morrisjs-rails'
require 'momentjs-rails'
require 'haml-rails'
require 'sass-rails'

require 'models/graph/data'
require 'models/graph/data/room'

module Graph
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  mattr_accessor :source_table
  @@source_table = :archive_block_availabilities
  
  mattr_accessor :room_class
  @@room_class = '::Room'

  mattr_accessor :room_price_class
  @@room_price_class = '::RoomPrice'

  def self.setup
    yield self
  end

  def self.room
    @@room_class.constantize
  end

  def self.room_price
    @@room_price_class.constantize
  end

  class Engine < ::Rails::Engine
    isolate_namespace Graph

    config.generators do |g|
      g.test_framework :rspec, fixture_replacement: :fabrication
      g.fixture_replacement :fabrication, dir: 'spec/fabricators'

      g.assets false
      g.view_specs false
      g.helper_specs false
    end
  end
end
