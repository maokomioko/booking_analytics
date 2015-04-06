$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'price_maker/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'price_maker'
  s.version     = PriceMaker::VERSION
  s.authors     = ['sigra']
  s.email       = ['sigra.yandex@gmail.com']
  s.homepage    = 'https://github.com/maokomioko/booking_analytics/'
  s.summary     = 'PriceMaker.'
  s.description = 'Tricky algorithm.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'celluloid'
  s.add_dependency 'sidekiq'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'fabrication'
end
