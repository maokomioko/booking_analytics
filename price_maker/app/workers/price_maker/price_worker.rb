module PriceMaker
  class PriceWorker
    include Sidekiq::Worker

    sidekiq_options retry: false, unique: true, queue: 'alg'

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
