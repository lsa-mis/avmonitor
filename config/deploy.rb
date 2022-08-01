# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

# set :stages, %w(staging)
# set :default_stage, "staging"

set :pty,             true
set :stage,           :staging

# set :rbenv_type, :user
# set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :application, "avmonitor"
set :repo_url, "git@github.com:lsa-mis/avmonitor.git"
set :deploy_via, :remote_cache 
set :user, 'deployer'
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"  # :user is in Capfile
set :shared_path,     "#{fetch(:deploy_to)}/shared"
set :tmp_dir, "/home/deployer/tmp" #"#{fetch(:home)}/tmp"
set :keep_releases, 3

# set :default_environment["LD_LIBRARY_PATH"] = "/opt/oracle/instantclient_21_7:$LD_LIBRARY_PATH"

# set :linked_files, %w{config/puma.rb config/nginx.conf config/master.key config/puma.service config/lsa-was-base-008e5e92455f.json}
# set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :linked_files, %w{config/puma.rb config/nginx.conf config/master.key config/puma.service}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure


namespace :debug do
  desc 'Print ENV variables'
  task :env do
    on roles(:app), in: :sequence, wait: 5 do
      execute :printenv
    end
  end
end

namespace :deploy do
  desc 'Upload to shared/config'
  task :upload do
    on roles (:app) do
    upload! "config/master.key",  "#{fetch(:shared_path)}/config/master.key"
    upload! "config/puma_staging.rb",  "#{fetch(:shared_path)}/config/puma.rb"
    upload! "config/nginx_staging.conf",  "#{fetch(:shared_path)}/config/nginx.conf"
    upload! "config/puma_staging.service",  "#{fetch(:shared_path)}/config/puma.service"
    end
  end
end

namespace :maintenance do
  desc "Maintenance start (edit config/maintenance_template.yml to provide parameters)"
  task :start do
    on roles(:web) do
      upload! "config/maintenance_template.yml", "#{current_path}/tmp/maintenance.yml"
    end
  end

  desc "Maintenance stop"
  task :stop do
    on roles(:web) do
      execute "rm #{current_path}/tmp/maintenance.yml"
    end
  end
end