require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
require 'fabrication/syntax/make'
require 'sidekiq/testing'
require 'vcr'
require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include JsonSpec::Helpers

  config.use_transactional_fixtures = false
  config.failure_color = :magenta
  config.tty = true
  config.color = true
  config.infer_spec_type_from_file_location!

  Sidekiq::Testing.fake!
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true

  c.filter_sensitive_data('%LOGIN%') { 'previo_login' }
  c.filter_sensitive_data('%PASSWORD%') { 'top_secret_password' }
end

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

options = {
  js_errors: false,
  timeout: 600,
  phantomjs_logger: StringIO.new,
  logger: nil,
  # debug: true,
  # inspector: true,
  phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']
}
Capybara.register_driver(:poltergeist) do |app|
  Capybara::Poltergeist::Driver.new app, options
end

Capybara.asset_host = 'http://localhost:3000'
