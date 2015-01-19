lock '3.2.1'
set :ssh_options, keepalive: true
set :application, 'booking_analytics'
set :repo_url, 'git@ba-app.imarto.com/var/www/ba_app'
set :rvm_ruby_version, "2.2.0"

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
    # invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end


  namespace :assets do

    desc "Precompile assets locally and then rsync to web servers"
    task :precompile_local do
      # compile assets locally
      run_locally do
        execute "RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      end

      # rsync to each server
      local_dir = "./public/assets/"
      on roles( fetch(:assets_roles, [:web]) ) do
        # this needs to be done outside run_locally in order for host to exist
        remote_dir = "#{host.user}@#{host.hostname}:#{release_path}/public/assets/"

        run_locally { execute "rsync -av --delete #{local_dir} #{remote_dir}" }
      end

      # clean up
      run_locally { execute "rm -rf #{local_dir}" }
    end

  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
