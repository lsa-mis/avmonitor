module ApplicationHelper

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
    devices = get_room_asset_devices(room)
    att = false
    catch :attention do
      devices.each do |device|
        DeviceCurrentState.where(device_id: device.id).each do |state|
          if state_need_attention?(state)
            att = true
            throw :attention 
          end
        end
      end
    end
    return att
  end
  
  def source_volume(room)
    room_device = get_room_device(room)
    if room_device.device_current_states.where(key: "Source Volume").last.present?
      return room_device.device_current_states.where(key: "Source Volume").last.value
    else
      return ""
    end
  end

  def ceiling_mic(room)
    room_device = get_room_device(room)
    if room_device.device_current_states.where(key: "Ceiling Mic Signal").last.present?
      return room_device.device_current_states.where(key: "Ceiling Mic Signal").last.value
    else 
      return "not available"
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
      return "not available"
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
      return device.device_current_states.where(key: "Power Is On").last.value
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
    device = Device.find_by(name: "Room", room_id: room.id)
    if device.present? && DeviceCurrentState.where(device_id: device.id).present?
      if DeviceCurrentState.where(device_id: device.id).last.key == "Room Is On" && device.device_current_states.last.value == "false"
        return true
      else
        return false
      end
    else 
      return true
    end
  end

  def rooms_need_attention(rooms)
    attention_rooms = []
    rooms.each do |room|
      if room_is_off?(room)
        attention_rooms << room
      else
        devices = Device.where(room_id: room.id).where.not(name: 'Room')
        catch :attention do
          devices.each do |device|
            DeviceCurrentState.where(device_id: device.id).each do |state|
              if state_need_attention?(state)
                attention_rooms << room
                throw :attention 
              end
            end
          end
        end
      end
    end
    return attention_rooms
  end

end
