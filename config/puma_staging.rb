#!/usr/bin/env puma

directory '/home/deployer/apps/avmonitor/current'
rackup "/home/deployer/apps/avmonitor/current/config.ru"
environment 'staging'

pidfile "/home/deployer/apps/avmonitor/shared/tmp/pids/puma.pid"
state_path "/home/deployer/apps/avmonitor/shared/tmp/pids/puma.state"
stdout_redirect '/home/deployer/apps/avmonitor/current/log/puma.error.log', '/home/deployer/apps/avmonitor/current/log/puma.access.log', true

threads 4,16

bind 'unix:///home/deployer/apps/avmonitor/shared/tmp/sockets/avmonitor-puma.sock'

workers 0

preload_app!
on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/deployer/apps/avmonitor/current/Gemfile"
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end