class BlockAvailabilityWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false, unique: true

  # recurrence { daily.hour_of_day(1, 5, 9, 13, 17, 21) } # UTC

  def perform
    BlockAvailability.find_in_batches(batch_size: 1000) do |batch|
      BlockAvailabilityBatchWorker.perform_async batch.map(&:id)
    end
  end
end