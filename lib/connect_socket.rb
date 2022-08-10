class ConnectSocket

  require 'faye/websocket'
  require 'eventmachine'
  require "rack"
  require "thin"
  require 'em-redis'
  require 'typhoeus'

  def initialize(wssName, wssUri, thin_port)
    @wssName = wssName
    @wssUri = wssUri
    @thin_port = thin_port
  end

  def connect
    socket_app = lambda do |env|
      EM.run {
        puts "in class Socket"
        puts @wssName
        puts @wssUri
        redis = EM::Protocols::Redis.connect
        redis.errback do |code|
          puts "Error code: #{code}"
        end

        ws = Faye::WebSocket::Client.new(@wssUri, [], :tls => {
          :verify_peer => false
        })

        ws.on :open do |event|
          ws.send("{'LSARoom': {'Password': 'LSAPassword'}}")
        end

        ws.on :message do |event|
          p "#{@wssName} socket is responding - #{Time.now}"
          redis.set @wssName, event.data do |response|
            redis.get @wssName do |response|
              p response
            end
          end
        end
      
        ws.on :close do |event|
          p ["#{@wssName}", :close, event.code, event.reason]
          ws = nil
        end
      }
    end
    Rack::Handler::Thin.run socket_app, Port: @thin_port
    Typhoeus.get("http://localhost:#{@thin_port}/")
  end
end