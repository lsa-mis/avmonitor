#!/usr/bin/env ruby
require 'mysql2'
require_relative 'connect_socket'

begin
  # connect to the MySQL server
  dbh = Mysql2::Client.new(host: "localhost", username: "root", password: "I9qACl7Jl3xobBZqQM", database: "avm_development")
  # get server version string and display it
  results = dbh.query("SELECT websocket_ip, websocket_port, facility_id FROM rooms")
  tport = 8080
  threads = []
  results.each do |row|
    puts "in loop"
    socket = "wss://" + row['websocket_ip'] + ":" + row['websocket_port']
    # socket = "hello"
    name = row['facility_id']
    puts name
    puts socket
    puts tport
    wss_instance = ConnectSocket.new(name, socket, tport)
    # app = wss_socket.connect
    threads << Thread.new { wss_instance.connect }
    tport += 1
  end

rescue Exception => e
  puts "error raised"
  puts [e, e.backtrace].flatten.join("\n")
end
threads.each(&:join)
sleep(300)