require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'

require 'whenever/capistrano'

require 'capistrano/sidekiq'
require 'capistrano/sidekiq/monit'
require 'capistrano/unicorn_nginx'

require 'rollbar/capistrano3'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
