class CacheExchangeRatesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false, unique: true

  recurrence { hourly.minute_of_hour(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) }

  def perform
    rates = Money.default_bank.save_rates_to_s
    Rails.cache.write('money:exchange_rates', rates)
    rates
  end
end
