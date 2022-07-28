module ApplicationHelper

  def svg(svg)
    file_path = "app/assets/images/svg/#{svg}.svg"
    return File.read(file_path).html_safe if File.exist?(file_path)
    file_path
  end

  def room_state?(room)
    Device.find_by(name: "Room", room_id: room.id).present?
  end

  def get_room_device(room)
    Device.find_by(name: "Room", room_id: room.id)
  end

  def room_assets?(room)
    Device.where(room_id: room.id).where.not(name: 'Room').present?
  end

  def room_has_device_states?(room)
    devices = Device.where(room_id: room.id)
    state_exist = false
    catch :state do
      devices.each do |device|
        if device.device_states.present?
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

  def state_need_attention?(state)
    (state.key == "Online" && state.value == "false") || ( state.key == "Error State" && state.value == "true")
  end

  def room_need_attention?(room)
    devices = get_room_asset_devices(room)
    att = false
    catch :attention do
      devices.each do |device|
        DeviceState.where(device_id: device.id).select(:key, :value, 'MAX(created_at)').group(:key, :value).each do |state|
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
    if room_device.device_states.where(key: "Source Volume").last.present?
      return room_device.device_states.where(key: "Source Volume").last.value
    else
      return ""
    end
  end

  def ceiling_mic(room)
    room_device = get_room_device(room)
    if room_device.device_states.where(key: "Ceiling Mic Signal").last.present?
      return room_device.device_states.where(key: "Ceiling Mic Signal").last.value
    else 
      return "not available"
    end
  end

  def wl_mic(room)
    room_device = get_room_device(room)
    if room_device.device_states.where(key: "WL Mic Signal").last.present?
      return room_device.device_states.where(key: "WL Mic Signal").last.value
    else 
      return "not available"
    end
  end

  def wl_mic_volume(room)
    room_device = get_room_device(room)
    if room_device.device_states.where(key: "Mic Volume").last.present?
      return room_device.device_states.where(key: "Mic Volume").last.value
    else 
      return "not available"
    end
  end

  def lamp_hour(device)
    if device.device_states.where(key: "Lamp Hours").last.present?
      return device.device_states.where(key: "Lamp Hours").last.value
    else
      return ""
    end
  end

  def device_online(device)
    if device.device_states.pluck(:key).include?("Online")
      return device.device_states.where(key: "Online").last.value
    else
      return "-"
    end
  end

  def device_power_is_on(device)
    if device.device_states.pluck(:key).include?("Power Is On")
      return device.device_states.where(key: "Power Is On").last.value
    else
      return "-"
    end
  end

  def video_source_device?(device)
    # check if a device in not a Touch panel. Tauch Panel doesn't have "Power Is On" key
    device.device_states.pluck(:key).include?("Power Is On")
  end

  def current_source(room, device)
    room_device = get_room_device(room)
    device_number = device.name.split(" ").last
    source_key = "Current Source " + device_number
    if room_device.device_states.where(key: source_key).last.present?
      source = room_device.device_states.where(key: source_key).last.value
      if source != "0"
        return room_device.device_states.where("`key` LIKE 'VideoSource%' AND `key` LIKE '%" + "#{source}'").last.value
      else
        return "not selected"
      end
    else 
      return "not available"
    end
  end

  def room_is_off?(room)
    device = Device.find_by(name: "Room", room_id: room.id)
    if device.present? && DeviceState.where(device_id: device.id).present?
      if DeviceState.where(device_id: device.id).last.key == "Room Is On" && device.device_states.last.value == "false"
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
            DeviceState.where(device_id: device.id).select(:key, :value, 'MAX(created_at)').group(:key, :value).each do |state|
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

  def write_socket_data_to_db(room, input, data)
    case input
    when "BooleanInputs"
      # write states to the device "Room"
      unless Device.find_by(room_id: room.id, name: "Room").present?
      Device.create(room_id: room.id, name: "Room")
      end
      device = Device.find_by(room_id: room.id, name: "Room")
      data.each do |key, value|
        DeviceState.create(device_id: device.id, key: key, value: value.to_s)
      end
    when "ShortIntegerInputs"
      # write states to the device "Room"
      device = Device.find_by(room_id: room.id, name: "Room")
      data.each do |key, value|
        DeviceState.create(device_id: device.id, key: key, value: value.to_s)
      end
    when "StringInputs"
      # write states to the device "Room"
      device = Device.find_by(room_id: room.id, name: "Room")
      data.each do |key, value|
        DeviceState.create(device_id: device.id, key: key, value: value.to_s)
      end
    when "Assets"
      data.each do |asset, data|
        Device.create(room_id: room.id, name: asset) unless Device.find_by(room_id: room.id, name: asset).present?
        device = Device.find_by(room_id: room.id, name: asset)
        data.each do |name, states|
          case name
          when "BooleanInputs"
            # write states to the assets' device
            states.each do |key, value|
              DeviceState.create(device_id: device.id, key: key, value: value.to_s)
            end
          when "ShortIntegerInputs"
            # write states to the assets' device
            device = Device.find_by(room_id: room.id, name: "Room")
            states.each do |key, value|
              DeviceState.create(device_id: device.id, key: key, value: value.to_s)
            end
          end
        end
      end
    end
  end

end
