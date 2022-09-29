class SendSocketJob
  include Sidekiq::Job

  def perform(websocket_ip, websocket_port, facility_id)
    p "$$$$$$$$$$$$$Send #{facility_id} socket"
    socket = "wss://" + websocket_ip + ":" + websocket_port
    wss_instance = WebsocketFactory.new(facility_id, socket)
    wss_instance.send_message
  end


end
