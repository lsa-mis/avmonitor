json.extract! room, :id, :websocket_ip, :websocket_port, :facility_id, :building, :room_type, :created_at, :updated_at
json.url room_url(room, format: :json)
