require 'faye/websocket'
require 'eventmachine'
require "rack"
require "thin"
require 'em-redis'

app = lambda do |env|
  EM.run {
    wssName = 'LSARoom'
    wssUri = 'wss://141.213.179.84:32123'

    redis = EM::Protocols::Redis.connect
    redis.errback do |code|
      puts "Error code: #{code}"
    end

    ws = Faye::WebSocket::Client.new(wssUri, [], :tls => {
      :verify_peer => false
    })

    ws.on :open do |event|
      ws.send("{'LSARoom': {'Password': 'LSAPassword'}}")
    end

    ws.on :message do |event|
      p "#{wssName} socket is responding - #{Time.now}"
      redis.set wssName, event.data do |response|
        redis.get wssName do |response|
          p response
        end
      end
    end
  
    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end
  }
end

Rack::Handler::Thin.run app, Port: 8080
