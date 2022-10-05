class SendSocketJob
  include Sidekiq::Job

  def perform(websocket_ip, websocket_port, facility_id, msg)
    p "$$$$$$$$$$$$$Send #{facility_id} socket - msg = #{msg}"
    socket = "wss://" + websocket_ip + ":" + websocket_port
    wss_instance = WebsocketFactory.new(facility_id, socket)
    wss_instance.send_message(msg)
  end


end
