module PriceMaker
  class PriceWorker
    include Sidekiq::Worker
    include Sidetiq::Schedulable

    sidekiq_options retry: false, unique: true

    # recurrence { hourly(3) }

    def perform
      ChannelManager.each do |auth|
        unless auth.rooms.nil?
          auth.rooms.real.each do |room|
            room.fill_prices
          end
        end
      end
    end
  end
end
