require 'faye/websocket'
require 'eventmachine'
require "rack"
require "thin"
require 'em-redis'
require 'rake'

app = lambda do |env|
  EM.run {
    wssName = 'LSARoom'
    wssUri = 'wss://141.213.179.84:32123'
    wssIp = '141.213.179.84'
    wssPort = '32123'
    # websocket = Websocket.new(wssIp, wssPort, wssName)

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

      # unless websocket
      #   # room with this websocket doesn't exist in the db - do something
      # end

      # websocket.process_payload(event_data)
      # Rake.application.rake_require 'test_task', ['../tasks']
      # ENV['ENVIRONMENT'] = 'development'
      # Rake.application['test_task'].invoke

      redis.set wssName, event.data do |response|
        redis.get wssName do |response|
          p response
          # write to ActiveRecord
          # "{"LSARoom": {"BooleanInputs": {"Ceiling Mic Signal": true } }}"

          # def create_state
            # room = Room.find_by(facility_id: XX )
            # if BooleanInputs
              # device = Device.find_by(name: "Room", room_id: room.id)
              # DeviceState.create(devide_id: device.id, key: "Ceiling Mic Signal", value: true)
            #end
            # if ShortIntegerInputs
              # device = Device.find_by(name: "Room", room_id: room.id)
              # DeviceState.create(devide_id: device.id, key: "Ceiling Mic Signal", value: true)
            #end
            # if StringInputs
              # device = Device.find_by(name: "Room", room_id: room.id)
              # DeviceState.create(devide_id: device.id, key: "Ceiling Mic Signal", value: true)
            #end

            # if Assets
             # Loop through assets
              # for each asset 
              #   Read device name
              #   Check if it exists
              #   If exists
                    # device = Device.find_by(name: ##assetName##, room_id: room.id)
                    # DeviceState.create(devide_id: device.id, key: ##key Name##, value: true)
              #   else
                    # Create Device
                    # Create DeviceState
                  # end
                #end
            #end
          # end
        end
      end
    end
  
    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end

    # loop do
    #   ws.send STDIN.gets.strip
    # end
  }
end

Rack::Handler::Thin.run app, Port: 8080
