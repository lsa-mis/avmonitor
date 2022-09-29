class CreateSocketJob
  include Sidekiq::Job

  def perform(websocket_ip, websocket_port, facility_id)
    p "$$$$$$$$$$$$$Create #{facility_id} socket"
    socket = "wss://" + websocket_ip + ":" + websocket_port
    wss_instance = WebsocketFactory.new(facility_id, socket)
    wss_instance.create_socket
    # puts "$$$$$$$$$$$$$returned"
    # wss_instance.wss.send("{'LSARoom': {'Password': 'LSAPassword'}}")

    # puts "$$$$$$$$$$$$$class of wss: #{wss_instance.wss.class}"
    # puts "$$$$$$$$$$$$$class of wss_methods: #{wss_instance.wss.methods}"
    # puts "$$$$$$$$$$$$$tried to send to socket again"
  end


end
