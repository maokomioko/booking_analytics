class BlockAvailabilityBatchWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(ids)
    BlockAvailability.where(id: ids).each do |block|
      BlockAvailabilityParser.new(block).parse rescue nil
    end
  end
end