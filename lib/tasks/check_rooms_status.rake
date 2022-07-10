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
    if Attention.last.message == ''
      puts "change from Ok to Attention"
      Attention.create(message: "Attention needed")
    end
    puts "change Attention again"
      ActionCable.server.broadcast("attention_channel", { message: "Attention needed"})
  else
    puts "status is OK"
    if Attention.last.message == "Attention needed"
      puts "change from Attention to Ok"
      Attention.create(message: "")
      ActionCable.server.broadcast("attention_channel", { message: ""})
    end
    puts "don't change"
  end
  
end