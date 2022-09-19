class WebsocketFactory

  require 'faye/websocket'
  require 'eventmachine'
  require 'em-redis'

  def initialize(wssName, wssUri)
    @wssName = wssName
    @wssUri = wssUri
  end

  def create_socket
    puts "** in WebsocketFactory::create_socket method for #{@wssName}"
      EM.run {
        redis = EM::Protocols::Redis.connect
        redis.errback do |code|
          puts "Error code: #{code}"
        end

        wss = Faye::WebSocket::Client.new(@wssUri, [], :tls => {
          :verify_peer => false
        })

        p ["#{@wssName} - send close to #{wss}", :close]
        sleep 2
        p ["#{@wssName} - send initial message to #{wss}", :open]

        wss.on :open do |event|
          wss.send("{'LSARoom': {'Password': 'LSAPassword'}}")
        end

        wss.on :message do |event|
          p "#{@wssName} - socket is responding - #{Time.now}"
          redis.set @wssName, event.data do |response|
            redis.get @wssName do |response|
              p response
            end
          end
        end
      
        wss.on :close do |event|
          p ["#{@wssName}", :close, event.code, event.reason]
          wss = nil
        end
      }
      puts "*!*! ended WebsocketFactory::create_socket method for #{@wssName}"
  end

  def send_message(socket_name)
    socket_name.send("{'LSARoom': {'Password': 'LSAPassword'}}")
  end

end