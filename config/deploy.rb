set :ssh_options, keepalive: true
set :application, 'booking_analytics'
set :repo_url, 'git@github.com:maokomioko/booking_analytics.git'
set :rvm_ruby_version, "rbx-2.5.2@booking"

Rake::Task["deploy:compile_assets"].clear

set :deploy_to, '/var/www/booking'
set :branch, 'alg_cleanup'
set :pty,  false # To ensure Sidekiq starts fine

set :assets_roles, [:web, :app]

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :keep_releases, 3

set :bundle_path, -> { shared_path.join('vendor/bundle') }

namespace :deploy do

  desc 'Compile assets'
  task compile_assets: [:set_rails_env] do
    invoke 'deploy:assets:precompile'
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
