class StartSingleSocketJob

  include Sidekiq::Job
  queue_as :default

  def perform(websocket_ip, websocket_port, facility_id, tport)
      socket = "wss://" + websocket_ip + ":" + websocket_port
      wss_instance = ConnectSocket.new(facility_id, socket, tport)
      Thread.new { wss_instance.create_socket }
      Thread.new { puts "Hello Ananta"}.join
  end
end
