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
    config.i18n.fallbacks = true

    config.generators do |g|
      g.test_framework :rspec, fixture_replacement: :fabrication
      g.fixture_replacement :fabrication, dir: 'spec/fabricators'

      g.view_specs false
      g.helper_specs false
    end

    config.railties_order = [:main_app, :all]
    config.active_record.raise_in_transactional_callbacks = true

    CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

    # mapping custom errors
    config.action_dispatch.rescue_responses.merge! 'CanCan::AccessDenied' => :forbidden

    config.cache_store = :redis_store, ENV['REDISCLOUD_URL'] || 'redis://localhost:6379/0/cache', { expires_in: 3.days }
  end
end
