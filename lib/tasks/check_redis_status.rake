desc "This will find rooms that need attention"
task check_redis_status: :environment do

  # need to config redis
  # run these commands in redis-cli
  # CONFIG SET notify-keyspace-events KEA
  # psubscribe '__key*__:*'

  require 'redis'
  redis = Redis.new(host: "localhost")

  def write_socket_data_to_db(room, payload)
    payload["LSARoom"].each do |input, data|
      if input == "Assets"
        data.each do |asset, device_data|
          Device.where(room_id: room.id, name: asset).first_or_create
          device = Device.find_by(room_id: room.id, name: asset)
          device_data.each do |name, states|
            if name == "BooleanInputs" || name == "ShortIntegerInputs"
              states.each do |key, value|
                DeviceState.create(device_id: device.id, key: key, value: value.to_s)
                DeviceCurrentState.where(device_id: device.id, key: key).first_or_create.update(value: value.to_s)
              end
            end
          end
        end
      else
        if input == "BooleanInputs" || input == "ShortIntegerInputs" || input == "StringInputs"
          Device.where(room_id: room.id, name: "Room").first_or_create
          device = Device.find_by(room_id: room.id, name: "Room")
          data.each do |key, value|
            DeviceState.create(device_id: device.id, key: key, value: value.to_s)
            DeviceCurrentState.where(device_id: device.id, key: key).first_or_create.update(value: value.to_s)
          end
        end
      end
    end
  end

  def write_socket_status_to_db(room, status)
    SocketStatus.where(socket_name: room).first_or_create.update(status: status)
  end
  
  Sidekiq.redis do |conn|
    # https://redis.io/topics/notifications#configuration
    conn.config(:set, "notify-keyspace-events", "E$lshz")
    # https://redis.io/topics/notifications#events-generated-by-different-commands
    conn.psubscribe("__key*__:*") do |on|
      on.psubscribe do
        puts "SIDEKIQ-REDIS SUBSCRIBED"
      end
      on.pmessage do |pattern, command, room_name|
        # puts "SIDEKIQ-REDIS PATTERN: #{pattern}, COMMAND: #{command}, ROOM NAME: #{room_name}"
        # room_name - room's facility_id
        all_rooms = Room.all.pluck(:facility_id)
        if all_rooms.include?(room_name)
          room = Room.find_by(facility_id: room_name)
          redis_value = redis.get(room_name)
          payload = JSON.parse redis_value.gsub('=>', ':')
          write_socket_data_to_db(room, payload)
        elsif room_name.include? 'status'
          room = room_name.split("_").first
          status = redis.get(room_name)
          write_socket_status_to_db(room, status)
        end
      end
      on.punsubscribe do
        puts "SIDEKIQ-REDIS UN-SUBSCRIBED"
      end
    end
  end
  
end