module ApplicationHelper

	def svg(svg)
		file_path = "app/packs/images/svgs/#{svg}.svg"
		return File.read(file_path).html_safe if File.exist?(file_path)
		file_path
	end
	
end
