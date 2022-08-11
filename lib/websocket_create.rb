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

  # threads = []
  threads_create = []
  threads_connect = []
  results.each do |row|
    puts "in loop"
    socket = "wss://" + row['websocket_ip'] + ":" + row['websocket_port']
    name = row['facility_id']
    tport = row['tport']
    puts name
    puts socket
    puts tport
    wss_instance = ConnectSocket.new(name, socket, tport)
    # threads << Thread.new { wss_instance.connect }
    threads_create << Thread.new { wss_instance.create_socket }
    threads_connect << Thread.new { wss_instance.create_socket }
  end

rescue Exception => e
  puts "error raised"
  puts [e, e.backtrace].flatten.join("\n")
end
# if threads.any?
#   threads.each(&:join)
if threads_create.any?
  threads_create.each(&:join)
  threads_connect.each(&:join)
else 
  puts "There are no threads"
end
