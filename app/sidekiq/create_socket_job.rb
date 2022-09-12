class CreateSocketJob
  include Sidekiq::Job

  def perform(websocket_ip, websocket_port, facility_id, tport)
    p "Create #{facility_id} socket on #{tport}"
    socket = "wss://" + websocket_ip + ":" + websocket_port
    wss_instance = WebsocketFactory.new(facility_id, socket, tport)
    wss_instance.create_socket
  end

end
