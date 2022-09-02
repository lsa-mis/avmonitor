#!/usr/bin/env ruby
require 'mysql2'
require_relative 'connect_socket'

begin
  # connect to the MySQL server
  if ENV["RAILS_ENV"] == "staging"
    dbh = Mysql2::Client.new(host: ENV["DBHOST"], username: ENV["DBUSER"], password: ENV["DBPWD"], database: ENV["DBDATABASE"], sslca: ENV["SSLCA"] )
  else
    dbh = Mysql2::Client.new(host: "localhost", username: ENV["DBUSER"], password: ENV["DBPWD"], database: "avm_development" )
  end
  results = dbh.query("SELECT websocket_ip, websocket_port, facility_id, tport FROM rooms")

  threads_create = []
  # start dummy websocket
  results.each do |row|
    socket = "wss://" + row['websocket_ip'] + ":" + row['websocket_port']
    name = row['facility_id']
    tport = row['tport']
    wss_instance = ConnectSocket.new(name, socket, tport)
    threads_create << Thread.new { wss_instance.create_socket }
    puts "Thread created for #{name} - #{socket} - [#{tport}]"
  end

rescue Exception => e
  puts "error raised"
  puts [e, e.backtrace].flatten.join("\n")
end

if threads_create.any?
  threads_create.each(&:join)
else 
  puts "There are no threads"
end
