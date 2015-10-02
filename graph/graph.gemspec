$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'graph/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'graph'
  s.version     = Graph::VERSION
  s.authors     = ['sigra']
  s.email       = ['sigra.yandex@gmail.com']
  s.homepage    = 'https://github.com/maokomioko/booking_analytics'
  s.summary     = 'Graph module for BA'
  s.description = 'Graph module for BA'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.files.delete('spec/dummy/log')
  s.files.delete('spec/dummy/log/development.log')
  s.files.delete('spec/dummy/log/test.log')

  s.test_files = Dir['spec/**/*']
  s.require_paths = ['lib', 'app']

  s.add_dependency 'coffee-rails', '>= 4.1'
  s.add_dependency 'haml-rails'
  s.add_dependency 'rails', '>= 4.2'
  s.add_dependency 'sass-rails', '>= 5'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails', '>= 3.0'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'data_builder'
end
