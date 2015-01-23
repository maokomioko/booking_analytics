lock '3.2.1'
set :ssh_options, keepalive: true
set :application, 'booking_analytics'
set :repo_url, 'git@ba-dev.imarto.com:ba_app.git'
set :rvm_ruby_version, "rbx-2.5.0"

Rake::Task["deploy:compile_assets"].clear

set :deploy_to, '/var/www/booking'
set :branch, 'master'
set :pty,  false # To ensure Sidekiq starts fine

set :assets_roles, [:web, :app]

set :linked_files, %w{config/mongoid.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :keep_releases, 3

set :bundle_path, -> { shared_path.join('vendor/bundle') }

namespace :deploy do

  desc 'Compile assets'
  task compile_assets: [:set_rails_env] do
    invoke 'deploy:assets:precompile'
  end

  desc "Create MongoDB indexes"
  task :mongo_indexes do
    on roles(:app) do
      within release_path do
        with rails_env: :production do
          execute :rake, 'db:mongoid:create_indexes'
        end
      end
    end
  end

  after :publishing, :mongo_indexes

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :mongo_indexes, :restart
end
