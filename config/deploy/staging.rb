role :app, %w{maoko@ba-dev.imarto.com}
role :web, %w{maoko@ba-dev.imarto.com}
role :db,  %w{maoko@ba-dev.imarto.com}

server 'ba-dev.imarto.com', user: 'maoko', roles: %w{web app}

set :rails_env, "staging"
