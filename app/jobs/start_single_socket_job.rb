class StartSingleSocketJob

  require 'typhoeus'
  include Sidekiq::Job
  queue_as :default

  def perform(websocket_ip, websocket_port, facility_id, tport)
      socket = "wss://" + websocket_ip + ":" + websocket_port
      wss_instance = ConnectSocket.new(facility_id, socket, tport)
      wss_instance.create_socket
      Typhoeus.get("http://localhost:#{tport}/")
  end
end
