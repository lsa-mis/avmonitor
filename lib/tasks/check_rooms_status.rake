desc "This will find rooms that need attention"
task check_rooms_status: :environment do
  include ApplicationHelper

  attention = false
  Room.all.each do |room|
    devices = Device.where(room_id: room.id).where.not(name: 'Room')
    catch :attention do
      devices.each do |device|
        DeviceState.where(device_id: device.id).select(:key, :value, 'MAX(created_at)').group(:key).each do |state|
          if state_need_attention?(state)
            attention = true
            throw :attention 
          end
        end
      end
    end
  end
  if attention
    puts "Attention needed"
    ActionCable.server.broadcast("attention_channel", { message: "Attention needed"})
  else
    puts "status is OK"
    ActionCable.server.broadcast("attention_channel", { message: "ok"})
  end
  
  
end