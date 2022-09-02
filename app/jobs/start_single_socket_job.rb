class StartSingleSocketJob

  include Sidekiq::Job
  queue_as :default

  def perform(websocket_ip, websocket_port, facility_id, tport)
    dummy_socket = "wss://10.10.10.12:12345"
    wss_dummy = ConnectSocket.new("dummy_room", dummy_socket, 8099)
    socket = "wss://" + websocket_ip + ":" + websocket_port
    wss_instance = ConnectSocket.new(facility_id, socket, tport)
    thread1 = Thread.new { wss_dummy.create_socket }
    puts "after thread 1"
    thread2 = Thread.new { wss_instance.create_socket }
    puts "after thread 2"
    # thread1.join
    # puts "thread1.join"
    # thread2.join
    # puts "thread2.join"
    sleep(60)
    puts "after sleep"
    thread1.exit
    puts "after exit"
  end
end
