class WebsocketFactory

  require 'faye/websocket'
  require 'eventmachine'
  require 'em-redis'

  attr_accessor :wss

  def initialize(wssName, wssUri, msg = nil)
    @wssName = wssName
    @wssUri = wssUri
    @wss = nil
    message = msg
  end

  
  def create_socket

      EM.run {
        redis = EM::Protocols::Redis.connect
        redis.errback do |code|
          puts "!***CREATE***! Redis Error code: #{code}"
        end

        @wss = Faye::WebSocket::Client.new(@wssUri, [], :tls => {
          :verify_peer => false
        })

        @wss.on :open do |event|
          redis.set "#{@wssName}_status", "socket_opened - #{Time.now}"
          p "!***CREATE***! in #{@wss} :open method"
          @wss.send("{'LSARoom': {'Password': 'LSAPassword'}}")
        end

        @wss.on :message do |event|
          p "!***CREATE***! #{@wssName} - socket is responding - #{Time.now}"
          redis.set @wssName, event.data do |response|
            redis.set "#{@wssName}_status", "socket_responding - #{Time.now}"
            redis.get @wssName do |response|
              p "!***CREATE***! WRITTEN TO REDIS: #{response}"
            end
          end
        end
      
        wss.on :close do |event|
          p ["!***CREATE***! #{@wssName} - close socket", :close, event.code, event.reason]
          redis.set "#{@wssName}_status", "socket_not_responding - #{Time.now}"
          @wss = nil
        end

         EM.add_periodic_timer(30) do
          p "&&&&&&&&&&&&&&!***CREATE*** ping"
          @wss.ping do
            redis.set "#{@wssName}_status", "socket_ponged - #{Time.now}"
          end 
        end
      }

    puts "!***CREATE***! ended WebsocketFactory::create_socket method for #{@wssName}"
  end


  def send_message(message)
    puts "!***SEND***! start WebsocketFactory::send_socket method for #{@wssName} - msg = #{message}"

      EM.run {
        redis = EM::Protocols::Redis.connect
        redis.errback do |code|
          puts "!***SEND***! Redis Error code: #{code}"
        end

        @wss = Faye::WebSocket::Client.new(@wssUri, [], :tls => {
          :verify_peer => false
        })

        @wss.send(message)

        @wss.on :message do |event|
          p "!***SEND***! #{@wssName} - socket is responding - #{Time.now}"
          redis.set @wssName, event.data do |response|
            redis.set "#{@wssName}_status", "socket responded after sending message - #{Time.now}"
            redis.get @wssName do |response|
              p "!***SEND***! WRITTEN TO REDIS: #{response}"
            end
          end
        end

        EM::Timer.new(5) do
          p "&&&&&&&&&&&&&&!***SEND*** stoped"
          redis.set "#{@wssName}_status", "socket stopped after sending message - #{Time.now}"
          EM.stop
        end
      }

    puts "!***SEND***! ended WebsocketFactory::send_socket method for #{@wssName}"
  end

  def socket_close
    puts "!***SOCKET CLOSE***! start WebsocketFactory #{@wssName}"

      EM.run {
        redis = EM::Protocols::Redis.connect
        redis.errback do |code|
          puts "!***SOCKET CLOSE***! Redis Error code: #{code}"
        end

        @wss = Faye::WebSocket::Client.new(@wssUri, [], :tls => {
          :verify_peer => false
        })

        @wss.close(1000, 'want to close')

        wss.on :close do |event|
          p ["!***SOCKET CLOSE***! #{@wssName} - close socket", :close, event.code, event.reason]
          redis.set "#{@wssName}_status", "socket_closed - #{Time.now}"
          @wss = nil
        end

        EM::Timer.new(5) do
          p "&&&&&&&&&&&&&&!***SOCKET CLOSE***! in EM::Timer"
          EM.stop
        end
      }

    puts "!***SOCKET CLOSE***! ended WebsocketFactory::send_socket method for #{@wssName}"
  end

end