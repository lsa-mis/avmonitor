class CheckStatus
	extend ApplicationHelper
	def initialize(message:)
    @message = message
  end

	def check_status

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
			Attention.last.update(message: @message)
		else
			puts "status is OK"
			Attention.last.update(message: "")
		end
		att = Attention.last

		ActiveCable.server.broadcast(
      "attention_channel",
      {
        message: att.message
      }
    )
	end
end