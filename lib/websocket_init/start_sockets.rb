#!/usr/bin/env ruby

require 'typhoeus'
# https://github.com/typhoeus/typhoeus

socket_port = (8080..8090).to_a

socket_port.each { |p| response = Typhoeus.get("http://localhost:#{p}/") }

