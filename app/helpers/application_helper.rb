module ApplicationHelper

	def svg(svg)
		file_path = "app/packs/images/svgs/#{svg}.svg"
		return File.read(file_path).html_safe if File.exist?(file_path)
		file_path
	end

	def get_room_device(room)
		Device.find_by(name: "Room", room_id: room.id)
	end

	def get_room_asset_devices(room)
		Device.where(room_id: room.id).where.not(name: 'Room')
	end

	def need_attention?(state)
		(state.key == "Online" && state.value == "false") || ( state.key == "Error State" && state.value == "true")
	end
	
	def source_volume(room)
		room_device = get_room_device(room)
		if room_device.device_states.where(key: "Source Volume").last.present?
			return room_device.device_states.where(key: "Source Volume").last.value
		else
			return ""
		end
	end

	def current_source(room)
		room_device = get_room_device(room)
		if room_device.device_states.where(key: "Current Source").last.present?
			source = room_device.device_states.where(key: "Current Source").last.value
			if source != "0"
				return room_device.device_states.where("key LIKE 'VideoSource%' AND key LIKE '%" + "#{source}'").last.value
			else
				return "not selected"
			end
		else 
			return "not available"
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
		device.device_states.pluck(:key).include?("Power Is On")
	end
	
end
