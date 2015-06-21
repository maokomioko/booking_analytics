require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'

require 'capistrano/sidekiq'
require 'capistrano/sidekiq/monit'

require 'capistrano/puma'
require 'capistrano/puma/workers'
require 'capistrano/puma/monit'
require 'capistrano/puma/nginx'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
