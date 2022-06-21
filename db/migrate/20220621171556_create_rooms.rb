class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :websocket_ip, null: false
      t.string :websocket_port, null: false
      t.string :facility_id, null: false
      t.string :building, null: false
      t.string :room_type, null: false

      t.timestamps
    end
  end
end
