require 'faye/websocket'
require 'eventmachine'
require "rack"
require "thin"
require 'em-redis'

appmh1339 = lambda do |env|
  EM.run {
    wssName = 'MH1339'
    wssUri = 'wss://10.211.103.182:32123'

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

Rack::Handler::Thin.run appmh1339, Port: 8082
