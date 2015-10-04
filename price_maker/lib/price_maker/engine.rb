require 'active_record'

module PriceMaker
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec, fixture_replacement: :fabrication
      g.fixture_replacement :fabrication, dir: 'spec/fabricators'

      g.assets false
      g.view_specs false
      g.helper_specs false
    end

    initializer 'price_maker.load_workers' do
      Dir["#{root}/app/workers/**/*.rb"].each { |file| require file }
    end
  end
end
