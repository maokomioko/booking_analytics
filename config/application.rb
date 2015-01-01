require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BookingAnalytics
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    config.allow_concurrency = true
    config.i18n.default_locale = :en
  end
end
