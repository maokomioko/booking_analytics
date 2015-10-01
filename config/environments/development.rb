Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :letter_opener

  # config.action_mailer.default_url_options = { host: 'hotelcommander.net' }
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   user_name: 'mikeeirih@me.com',
  #   password: 'ySjWppj6lCh7hE643bsXtw',
  #   address: 'smtp.mandrillapp.com',
  #   port: 587,
  #   enable_starttls_auto: true,
  #   authentication: 'login'
  # }

  config.dev_tweaks.autoload_rules do
    keep :all

    skip '/favicon.ico'
    skip :assets
    keep :forced
  end
end
