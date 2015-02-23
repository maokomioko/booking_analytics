role :app, %w{mikeeirih@81.25.161.2}
role :web, %w{mikeeirih@81.25.161.2}
role :db,  %w{mikeeirih@81.25.161.2}

server '81.25.161.2', user: 'mikeeirih', roles: %w{web app}

set :rails_env, "staging"
set :rvm_ruby_version, "rbx-2.5.2@booking_staging"

set :branch, '1_pg'
set :ssh_options, {
                    forward_agent: true,
                    port: 904
                }
