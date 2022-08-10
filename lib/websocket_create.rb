#!/usr/bin/env ruby
require 'mysql2'
require_relative 'connect_socket'

begin
  # connect to the MySQL server
  dbh = Mysql2::Client.new(host: "localhost", username: "root", password: "I9qACl7Jl3xobBZqQM", database: "avm_development")
  results = dbh.query("SELECT websocket_ip, websocket_port, facility_id, tport FROM rooms")

  threads = []
  results.each do |row|
    puts "in loop"
    socket = "wss://" + row['websocket_ip'] + ":" + row['websocket_port']
    name = row['facility_id']
    tport = row['tport']
    puts name
    puts socket
    puts tport
    wss_instance = ConnectSocket.new(name, socket, tport)
    threads << Thread.new { wss_instance.connect }
  end

rescue Exception => e
  puts "error raised"
  puts [e, e.backtrace].flatten.join("\n")
end
threads.each(&:join)
