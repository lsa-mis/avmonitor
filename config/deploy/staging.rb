# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "141.211.4.9", user: "deployer", roles: %w{app db web}
# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

set :branch, "staging"
set :rails_env, "staging"

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/user_name/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }

# namespace :rake do
#   desc "Invoke check_redis_redis rake task"
#   task :invoke_check_redis do
#     run "cd #{deploy_to}/current"
#     # run "bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}"
#     # run "bundle exec rake check_redis_status"
#     run("cd #{deploy_to}/current && bundle exec rake check_redis_status RAILS_ENV=staging")
#   end
# end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/staging`
        puts "WARNING: HEAD is not the same as origin/staging"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Upload to shared/config'
  task :upload do
    on roles (:app) do
      upload! "config/master.key",  "#{fetch(:shared_path)}/config/master.key"
      upload! "config/puma_staging.rb",  "#{fetch(:shared_path)}/config/puma.rb"
      upload! "config/nginx_staging.conf",  "#{fetch(:shared_path)}/config/nginx.conf"
      upload! "config/puma_staging.service",  "#{fetch(:shared_path)}/config/puma.service"
    end
  end

  desc "Invoke check_redis_redis rake task"
  task :invoke_check_redis do
    on roles(:app) do
      # nohup bundle exec rake check_redis_status > rake.out 2>&1 &
      execute "cd #{fetch(:deploy_to)}/current; nohup bundle exec rake check_redis_status > rake.out 2>&1 &"
    end
  end

  before :starting,     :check_revision
  after  :finishing,    'puma:restart'
  # after  :finishing,    :invoke_check_redis
end