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

    initializer 'price_maker.concerns' do
      ActionDispatch::Reloader.to_prepare do
        if (Room.connection rescue nil)
          Room.send(:include, PriceMaker::ChannelManager)
        end

        if (Hotel.connection rescue nil)
          Hotel.send(:include, PriceMaker::HotelAmenities)
        end
      end
    end

    initializer 'price_maker.load_workers' do
      Dir["#{self.root}/app/workers/**/*.rb"].each { |file| require file }
    end
  end
end
