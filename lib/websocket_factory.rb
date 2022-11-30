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
          redis.set "#{@wssName}_status", "opened - #{Time.now}"
          @wss.send("{'LSARoom': {'Password': 'LSAPassword'}}")
        end

        @wss.on :message do |event|
          redis.set @wssName, event.data do |response|
            redis.set "#{@wssName}_status", "responding - #{Time.now}"
          end
        end
      
        wss.on :close do |event|
          redis.set "#{@wssName}_status", "not_responding - #{Time.now}"
          @wss = nil
        end

         EM.add_periodic_timer(30) do
          @wss.ping do
            redis.set "#{@wssName}_status", "active - #{Time.now}"
          end 
        end
      }
  end


  def send_message(message, current_user)
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
          redis.set @wssName, event.data do |response|
            redis.set "#{@wssName}_status", "action received by #{current_user.name_with_uniqname} - #{Time.now}"
          end
        end

        EM::Timer.new(5) do
          redis.set "#{@wssName}_status", "action complete by #{current_user.name_with_uniqname}; open socket to stream socket data - #{Time.now}"
          EM.stop
        end

      }
  end

  def socket_close(current_user)
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
          p current_user
          redis.set "#{@wssName}_status", "closed by #{current_user.name_with_uniqname} - #{Time.now}"
          @wss = nil
        end

        EM::Timer.new(5) do
          EM.stop
        end
      }
  end

end