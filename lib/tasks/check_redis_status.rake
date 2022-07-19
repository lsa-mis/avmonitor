desc "This will find rooms that need attention"
task check_redis_status: :environment do

  require 'redis'
  redis = Redis.new(host: "localhost")

  Sidekiq.redis do |conn|
    # https://redis.io/topics/notifications#configuration
    conn.config(:set, "notify-keyspace-events", "E$lshz")
    # https://redis.io/topics/notifications#events-generated-by-different-commands
    conn.psubscribe("__key*__:*") do |on|
      on.psubscribe do
        puts "here one"
      end
      on.pmessage do |pattern, command, key|
        puts "in"
        puts key
        value = redis.get(key)
        puts value
        # Device.create(room_id: 1, name: value)
        puts "pattern"
        puts pattern
        puts "command"
        puts command
      end
      on.punsubscribe do
        puts "unsibscribe"
      end
    end
  end
  
end