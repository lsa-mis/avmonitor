#!/usr/bin/env ruby

require 'typhoeus'
# https://github.com/typhoeus/typhoeus

socket_port = [8080]

socket_port.each { |p| response = Typhoeus.get("http://localhost:#{p}/") }

