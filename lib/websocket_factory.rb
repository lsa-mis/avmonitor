class WebsocketFactory

  require 'faye/websocket'
  require 'eventmachine'
  require "rack"
  require "thin"
  require 'em-redis'

  def initialize(wssName, wssUri, thin_port)
    @wssName = wssName
    @wssUri = wssUri
    @thin_port = thin_port
  end

  def create_socket
    puts "in ConnectSocket::create_socket method for #{@wssName} - [#{@thin_port}]"
    socket_app = lambda do |env|
      EM.run {
        redis = EM::Protocols::Redis.connect
        redis.errback do |code|
          puts "Error code: #{code}"
        end

        @wssName_ws = Faye::WebSocket::Client.new(@wssUri, [], :tls => {
          :verify_peer => false
        })

        @wssName_ws.on :open do |event|
          @wssName_ws.send("{'LSARoom': {'Password': 'LSAPassword'}}")
        end

        @wssName_ws.on :message do |event|
          p "#{@wssName} - [#{@thin_port}] socket is responding - #{Time.now}"
          redis.set @wssName, event.data do |response|
            redis.get @wssName do |response|
              p response
            end
          end
        end
      
        @wssName_ws.on :close do |event|
          p ["#{@wssName} - [#{@thin_port}]", :close, event.code, event.reason]
          @wssName_ws = nil
        end
      }
    end
    Rack::Handler::Thin.run socket_app, Port: @thin_port
  end

end