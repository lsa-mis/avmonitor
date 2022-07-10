class DashboardController < ApplicationController
  include ApplicationHelper

  def index
   rooms =  Room.active
    attention_rooms = []
    rooms.each do |room|
      devices = Device.where(room_id: room.id).where.not(name: 'Room')
      catch :attention do
        devices.each do |device|
          DeviceState.where(device_id: device.id).select(:key, :value, 'MAX(created_at)').group(:key).each do |state|
            if state_need_attention?(state)
              attention_rooms << room
              throw :attention 
            end
          end
        end
      end
    end
    @rooms = attention_rooms
  end
end
