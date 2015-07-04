$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'overbooking/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'overbooking'
  s.version     = Overbooking::VERSION
  s.authors     = ['Andrey Yakovlev']
  s.email       = ['sigra.yandex@gmail.com']
  s.homepage    = 'http://hotelcommander.net'
  s.summary     = 'Overbooking plugin for HotelCommander'
  s.description = 'Overbooking plugin for HotelCommander'
  s.license     = 'ITS MINE'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.files.delete('spec/dummy/log')
  s.files.delete('spec/dummy/log/development.log')
  s.files.delete('spec/dummy/log/test.log')

  s.test_files = Dir['spec/**/*']
  s.require_paths = ['lib', 'app']

  s.add_dependency 'rails', '~> 4.2.3'
  s.add_dependency 'cancancan', '>= 1.10.1'
  s.add_dependency 'geocoder', '>= 1.2.9'
  s.add_dependency 'gmaps4rails', '>= 2.1.2'
  s.add_dependency 'google_directions', '>= 0.1.6'
  s.add_dependency 'haml-rails', '>= 0.9.0'
  s.add_dependency 'kaminari', '>= 0.16.3'
  s.add_dependency 'phony_rails', '>= 0.12.8'
  s.add_dependency 'roadie-rails', '>= 1.0.6'
  s.add_dependency 'underscore-rails', '>= 1.8.2'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'letter_opener', '>= 1.3'
end
