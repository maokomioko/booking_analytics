ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment',  __FILE__)

require 'database_cleaner'
require 'rspec/rails'
require 'data_builder'
require 'ffaker'
require 'fabrication'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, 'spec/support/**/*.rb')].each { |f| require f }

# Load fabricators
Dir[File.join(ENGINE_RAILS_ROOT, 'spec/fabricators/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  config.infer_spec_type_from_file_location!
end
