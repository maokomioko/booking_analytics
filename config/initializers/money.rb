MoneyRails.configure do |config|
  config.default_currency = :eur
  config.default_bank = EuCentralBank.new
  config.no_cents_if_whole = true
end
