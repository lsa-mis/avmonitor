desc "This will find websockets that are not responding"
task sockets_are_alive: :environment do
# run this task every SOCKET_ALIVE_PERIOD time
  require 'redis'
  redis = Redis.new(host: "localhost")

  # do we need a log file for this task?
  # @@socket_log ||= Logger.new("#{Rails.root}/log/sockets_are_alive.log")

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