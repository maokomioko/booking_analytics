require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Rack::Utils.multipart_part_limit = 0

module BookingAnalytics
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.precompile += %w( .svg .eot .woff .ttf)

    config.allow_concurrency = true
    config.i18n.default_locale = :en

    config.generators do |g|
      g.test_framework :rspec, fixture_replacement: :fabrication
      g.fixture_replacement :fabrication, dir: 'spec/fabricators'

      g.view_specs false
      g.helper_specs false
    end

    config.railties_order = [:main_app, :all]

    Money.default_currency = Money::Currency.new("EUR")
  end
end
