desc "This will find websockets that are not responding"
task sockets_are_alive: :environment do
# run this task every SOCKET_ALIVE_PERIOD time
  require 'redis'
  redis = Redis.new(host: "localhost")

  # do we need a log file for this task?
  # @@socket_log ||= Logger.new("#{Rails.root}/log/sockets_are_alive.log")

  # a ping is sent to a socket every SOCKET_ALIVE_PERIOD seconds
  # if a socket responces with a pong websocket_factory class write to redis: 
  #         redis.set "#{@wssName}_status", "#{Time.now}"
  # this task scans redis database for "*_status" keys (like "MH1339_status") and run a loop for every key
  # examples:
  # status: MH1339_status; redis.get(status): "2022-10-11 08:49:25.080945 -0400" (string)
  # status_time: redis.get(status) converted to Time object
  # facility_id: MH1339
  # device: a device with the name "Room" and MH1339's room_id 
  # if socket is not responging (Time.now - status_time > SOCKET_ALIVE_PERIOD)
  #   the task writes to DeviceSate or update DeviceCurrentState table for device: 
  #    key "Room Is On", value: "false"
  # if socket is alive: key "Room Is On", value: "true"

  # the key "Room Is On" is used in the [room_is_off?(room)] method to check if the room is Online/Offline

  Sidekiq.redis do |conn|
    redis.scan_each(match: "*_status") do |status|
      status_time = Time.parse(redis.get(status))
      facility_id = status.split("_").first
      if Room.find_by(facility_id: facility_id).present?
        room = Room.find_by(facility_id: facility_id)
        unless Device.find_by(name: "Room", room_id: room.id).present?
          Device.create(name: "Room", room_id: room.id)
        end
        device = Device.find_by(name: "Room", room_id: room.id)
        if Time.now - status_time > SOCKET_ALIVE_PERIOD
          # socket did not send a pong responce for longer than SOCKET_ALIVE_PERIOD time
          # Do we need to create this state for archived data?
          if DeviceState.where(device_id: device.id, key: "Room Is On").last.value == "true"
            DeviceState.create(device_id: device.id, key: "Room Is On", value: "false")
          end
          DeviceCurrentState.where(device_id: device.id, key: "Room Is On").first_or_create.update(value: "false")
        else
          if DeviceState.where(device_id: device.id, key: "Room Is On").last.value == "false"
            DeviceState.create(device_id: device.id, key: "Room Is On", value: "true")
          end
          DeviceCurrentState.where(device_id: device.id, key: "Room Is On").first_or_create.update(value: "true")
        end
      else
        #  what to do? nothing ?
      end
    end
  end
  
end