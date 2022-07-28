desc "This will find rooms that need attention"
task check_rooms_status: :environment do
  include ApplicationHelper

  attention = false
  Room.active.each do |room|
    devices = Device.where(room_id: room.id).where.not(name: 'Room')
    catch :attention do
      if room_is_off?(room)
        attention = true
        throw :attention 
      else
        devices.each do |device|
          DeviceState.where(device_id: device.id).select(:key, :value, 'MAX(created_at)').group(:key, :value).each do |state|
            if state_need_attention?(state)
              attention = true
              throw :attention 
            end
          end
        end
      end
    end
  end
  if attention
    puts "Attention needed"
    if Attention.last.present? 
      if Attention.last.message == ''
        puts "change from Ok to Attention"
        Attention.create(message: "Attention needed")
      end
    else
      puts "create first Attention"
      Attention.create(message: "Attention needed")
    end
    puts "reload dashboard"
      ActionCable.server.broadcast("attention_channel", { message: "Attention needed"})
  else
    puts "status is OK"
    if Attention.last.present? && Attention.last.message == "Attention needed"
      puts "change from Attention to Ok"
      Attention.create(message: "")
      puts "reload dashboard"
      ActionCable.server.broadcast("attention_channel", { message: ""})
    end
  end
  
end