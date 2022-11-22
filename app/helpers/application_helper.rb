module ApplicationHelper

  def show_status(status)
    return "" if status.blank?
    time_string = status.split(" - ").last
    status_time = time_string.to_datetime
    status_to_display = status[0...status.rindex(' ')] 
    if status.include?("active") && (Time.now - status_time > 30)
      status_to_display += " - too old"
    end
    return status_to_display
  end

  def svg(svg)
    file_path = "app/assets/images/svg/#{svg}.svg"
    return File.read(file_path).html_safe if File.exist?(file_path)
    file_path
  end

  def get_room_device(room)
    Device.find_by(name: "Room", room_id: room.id)
  end

  def room_has_device_current_states?(room)
    devices = Device.where(room_id: room.id)
    state_exist = false
    catch :state do
      devices.each do |device|
        if device.device_current_states.present?
          state_exist = true
          throw :state
        end
      end
    end
    return state_exist
  end

  def get_room_asset_devices(room)
    Device.where(room_id: room.id).where.not(name: 'Room')
  end

  def get_current_states_for_device(device)
    DeviceCurrentState.where(device_id: device.id)
  end

  def state_need_attention?(state)
    (state.key == "Online" && state.value == "false") || ( state.key == "Error State" && state.value == "true")
  end

  def room_need_attention?(room)
    need_attention = false
    if SocketStatus.find_by(socket_name: room.facility_id).present? 
      if SocketStatus.find_by(socket_name: room.facility_id).status.include?("not_responding")
        return true
      end
      if SocketStatus.find_by(socket_name: room.facility_id).status.include?("active")
        status = SocketStatus.find_by(socket_name: room.facility_id).status
        time_string = status.split(" - ").last
        status_time = time_string.to_datetime
        if Time.now - status_time > 30
          return true
        end
      end
    end
    devices = get_room_asset_devices(room)
    if devices.empty?
      return true
    else
      catch :attention do
        devices.each do |device|
          DeviceCurrentState.where(device_id: device.id).each do |state|
            if state_need_attention?(state)
              need_attention = true
              throw :attention 
            end
          end
        end
      end
    end
    return need_attention
  end
  
  def source_volume(room)
    room_device = get_room_device(room)
    if room_device.device_current_states.where(key: "Source Volume").last.present?
      return room_device.device_current_states.where(key: "Source Volume").last.value
    else
      return 0
    end
  end

  def ceiling_mic(room)
    room_device = get_room_device(room)
    if room_device.device_current_states.where(key: "Ceiling Mic Signal").last.present?
      return room_device.device_current_states.where(key: "Ceiling Mic Signal").last.value
    else 
      return 0
    end
  end

  def wl_mic(room)
    room_device = get_room_device(room)
    if room_device.device_current_states.where(key: "WL Mic Signal").last.present?
      return room_device.device_current_states.where(key: "WL Mic Signal").last.value
    else 
      return "not available"
    end
  end

  def wl_mic_volume(room)
    room_device = get_room_device(room)
    if room_device.device_current_states.where(key: "Mic Volume").last.present?
      return room_device.device_current_states.where(key: "Mic Volume").last.value
    else 
      return 0
    end
  end

  def lamp_hour(device)
    if device.device_current_states.where(key: "Lamp Hours").last.present?
      return device.device_current_states.where(key: "Lamp Hours").last.value
    else
      return ""
    end
  end

  def device_online(device)
    if device.device_current_states.pluck(:key).include?("Online")
      return device.device_current_states.where(key: "Online").last.value
    else
      return "-"
    end
  end

  def device_power_is_on(device)
    if device.device_current_states.pluck(:key).include?("Power Is On")
      if device.device_current_states.where(key: "Power Is On").last.value == "true"
        return true
      else
        return false
      end
    else
      return "-"
    end
  end

  def video_source_device?(device)
    # check if a device in not a Touch panel. Tauch Panel doesn't have "Power Is On" key
    device.device_current_states.pluck(:key).include?("Power Is On")
  end

  def current_source(room, device)
    room_device = get_room_device(room)
    device_number = device.name.split(" ").last
    source_key = "Current Source " + device_number
    if room_device.device_current_states.where(key: source_key).last.present?
      source = room_device.device_current_states.where(key: source_key).last.value
      if source != "0" && room_device.device_current_states.where("`key` LIKE 'VideoSource%' AND `key` LIKE '%" + "#{source}'").last.present?
        return room_device.device_current_states.where("`key` LIKE 'VideoSource%' AND `key` LIKE '%" + "#{source}'").last.id
      else
        return "not selected"
      end
    else 
      return "not available"
    end
  end

  def list_of_sources(room)
    room_device = get_room_device(room)
    DeviceCurrentState.where("device_id = " + "#{room_device.id} AND `key` LIKE 'VideoSource%' AND value <> ''")
  end

  def room_is_off?(room)
    if SocketStatus.find_by(socket_name: room.facility_id).present? 
      if SocketStatus.find_by(socket_name: room.facility_id).status.include?("not_responding")
        return true
      end
      if SocketStatus.find_by(socket_name: room.facility_id).status.include?("active")
        status = SocketStatus.find_by(socket_name: room.facility_id).status
        time_string = status.split(" - ").last
        status_time = time_string.to_datetime
        if Time.now - status_time > 30
          return true
        end
      end
    end
  end

  def rooms_need_attention(rooms)
    attention_rooms = []
    rooms.each do |room|
      if room_need_attention?(room)
        attention_rooms << room
      # else
      #   devices = Device.where(room_id: room.id).where.not(name: 'Room')
      #   catch :attention do
      #     devices.each do |device|
      #       DeviceCurrentState.where(device_id: device.id).each do |state|
      #         if state_need_attention?(state)
      #           attention_rooms << room
      #           throw :attention 
      #         end
      #       end
      #     end
      #   end
      end
    end
    return attention_rooms
  end

end
