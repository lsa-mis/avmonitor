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

  # def connect
  def create_socket
    puts "in ConnectSocket::create_socket method for #{@wssName} - [#{@thin_port}]"
    socket_app = lambda do |env|
      EM.run {
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
          p "#{@wssName} - [#{@thin_port}] socket is responding - #{Time.now}"
          redis.set @wssName, event.data do |response|
            redis.get @wssName do |response|
              p response
            end
          end
        end
      
        ws.on :close do |event|
          p ["#{@wssName} - [#{@thin_port}]", :close, event.code, event.reason]
          ws = nil
        end
      }
    end
    Rack::Handler::Thin.run socket_app, Port: @thin_port
    connect_to_socket(@thin_port)
  end
   
  def connect_to_socket(p)
    puts "In ConnectSocket::connect_to_socket method for #{@wssName} - [#{@thin_port}]"
    Typhoeus.get("http://localhost:#{p}/")
  end

end