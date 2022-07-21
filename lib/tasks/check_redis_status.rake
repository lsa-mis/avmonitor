desc "This will find rooms that need attention"
task check_redis_status: :environment do
  include ApplicationHelper

  # need to config redis
  # run these commands in redis-cli
  # CONFIG SET notify-keyspace-events KEA
  # psubscribe '__key*__:*'
  # 
  # start sockets scripst in different terminals: ruby lib/websocket_init/<script>
  # run: lib/websocket_init/start_sockets.rb
  # then run this task: bin/rake check_redis_status
  require 'redis'
  redis = Redis.new(host: "localhost")

  Sidekiq.redis do |conn|
    # https://redis.io/topics/notifications#configuration
    conn.config(:set, "notify-keyspace-events", "E$lshz")
    # https://redis.io/topics/notifications#events-generated-by-different-commands
    conn.psubscribe("__key*__:*") do |on|
      on.psubscribe do
        puts "subscribed"
      end
      on.pmessage do |pattern, command, room_name|
        puts room_name
        # room_name - room's facility_id
        if Room.find_by(facility_id: room_name).present?
          room = Room.find_by(facility_id: room_name)
          s = redis.get(room_name)
          puts s
          h = JSON.parse s.gsub('=>', ':')
          h["LSARoom"].each do |input, data|
            write_socket_data_to_db(room, input, data)
          end
        else 
          puts "no room with facility_id" + room_name
        end
      end
      on.punsubscribe do
        puts "unsubscribe"
      end
    end
  end
  
end