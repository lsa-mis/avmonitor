class WebsocketFactory

  require 'faye/websocket'
  require 'eventmachine'
  require 'em-redis'

  def initialize(wssName, wssUri)
    @wssName = wssName
    @wssUri = wssUri
  end

  def create_socket
    puts "!***CREATE***! start WebsocketFactory::create_socket method for #{@wssName}"

      EM.run {
        redis = EM::Protocols::Redis.connect
        redis.errback do |code|
          puts "!***CREATE***! Redis Error code: #{code}"
        end

        wss = Faye::WebSocket::Client.new(@wssUri, [], :tls => {
          :verify_peer => false
        })

        p ["!***CREATE***! #{@wssName} - send initial message to #{wss}", :open]
        redis.set "#{@wssName}_status", "socket_sent_open - #{Time.now}"

        wss.on :open do |event|
          redis.set "#{@wssName}_status", "socket_opened - #{Time.now}"
          wss.send("{'LSARoom': {'Password': 'LSAPassword'}}")
        end

        wss.on :message do |event|
          p "!***CREATE***! #{@wssName} - socket is responding - #{Time.now}"
          redis.set @wssName, event.data do |response|
            redis.get @wssName do |response|
              p "!***CREATE***! WRITTEN TO REDIS: #{response}"
            end
          end
        end
      
        wss.on :close do |event|
          p ["!***CREATE***! #{@wssName} - close socket", :close, event.code, event.reason]
          redis.set "#{@wssName}_status", "socket_closed - #{Time.now}"
          wss = nil
        end
      }
      
      puts "!***CREATE***! ended WebsocketFactory::create_socket method for #{@wssName}"                          
  end

end