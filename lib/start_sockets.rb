#!/usr/bin/env ruby
require 'mysql2'
require_relative 'connect_socket'
require 'sidekiq'
require_relative 'start_single_socket_job'


begin
  # connect to the MySQL server
  if ENV["RAILS_ENV"] == "staging"
    dbh = Mysql2::Client.new(host: ENV["DBHOST"], username: ENV["DBUSER"], password: ENV["DBPWD"], database: ENV["DBDATABASE"], sslca: ENV["SSLCA"] )
  else
    dbh = Mysql2::Client.new(host: "localhost", username: ENV["DBUSER"], password: ENV["DBPWD"], database: "avm_development" )
  end
  results = dbh.query("SELECT websocket_ip, websocket_port, facility_id, tport FROM rooms")
  # start dummy socket
  cmd_output = %x[lsof -i -P -n | grep LISTEN | grep 8999]
  if cmd_output == ''
    StartSingleSocketJob.perform_async("10.211.103.181", "32123", "dummy_room", "8999")
  end
  results.each do |row|
    StartSingleSocketJob.perform_async(row['websocket_ip'], row['websocket_port'], row['facility_id'], 
    row['tport'])
  end

rescue Exception => e
  puts "error raised"
  puts [e, e.backtrace].flatten.join("\n")
end
