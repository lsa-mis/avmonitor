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
	
end
