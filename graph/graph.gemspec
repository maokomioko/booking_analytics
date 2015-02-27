$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "graph/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "graph"
  s.version     = Graph::VERSION
  s.authors     = ["sigra"]
  s.email       = ["sigra.yandex@gmail.com"]
  s.homepage    = "nothing"
  s.summary     = "Graph module for BA"
  s.description = "Graph module for BA"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]
  s.require_paths = ['lib']

  s.add_dependency 'coffee-rails', '~> 4.1.0'
  s.add_dependency 'haml-rails'
  s.add_dependency 'morrisjs-rails'
  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'raphael-rails'
  s.add_dependency 'sass-rails', '>= 5'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'capybara'
end
