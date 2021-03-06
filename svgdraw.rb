require_relative("svgformat.rb")

class SVG_draw

	def initialize

		@format = SVG_format.new

	end

	def format; return @format end

	def canvas width, height, color
		content.unshift( draw.background(color) )
		content.unshift( draw.header(width, height) )
		content.push( draw.footer )
	end

	def header width, height
		name = "svg"
		hdr = [
			["version", "1.1"],
			["baseProfile", "full"],
			["width", width],
			["height", height],
			["xmlns","http://www.w3.org/2000/svg"]
		]
		return format.tag(format.build(name, hdr))

	end

	def footer; return "</svg>" end

	def background color
		name = "rect"
		bkg = [
			["x", 0],
			["y", 0],
			["width", "100%"],
			["height", "100%"],
			["fill", color],
		]
		return format.wrap(format.build(name,bkg))
	end

	def draw_text text, color, posx, posy, size, alignment
		name = "text"
		txt = [
			["x", posx],
			["y", posy],
			["fill",color],
			["font-family","Ubuntu Mono"],
			["font-size",size],
			["text-anchor", alignment],
			# ["transform","rotate(30,#{posx},#{posy})"],
			# ["stroke-alignment","outside"],
			# ["stroke","#000000"],
			# ["stroke-width", 2],
			["alignment-baseline", "central"]
		]
		return "#{format.tag(format.build(name,txt))}#{text}</text>"
	end

	# def draw_line

	# def draw_scale width, height, margin, color
	# 	name = "path"
	# 	pth = [
	# 	["d","M #{margin} #{margin}V #{height-margin} H #{width-margin}"],
	# 	["stroke",color],
	# 	["fill","none"]
	# 	]
	# 	return format.wrap(format.build(name,pth))
	# end

	def draw_polyline points, color, weight
		name = "polyline"
		ply = [
			["points", format.coordinates(points.flatten)],
			["stroke", color],
			["stroke-width", weight],
			# ["stroke-alignment", "left"], # TODO figure out how to align the stroke properly
			["fill", "none"]
		]
		return format.wrap(format.build(name,ply))
	end

	def draw_rect posx, posy, width, height, color
		name = "rect"
		rct = [
			["x", posx],
			["y", posy],
			["width", width],
			["height", height],
			["fill", color]
		]
		return format.wrap(format.build(name,rct))
	end
	# <circle cx="25" cy="75" r="20"/>

	def draw_circle posx, posy, radius, color
		name = "circle"
		rct = [
			["cx", posx],
			["cy", posy],
			["r", radius],
			["fill", color]
		]
		return format.wrap(format.build(name,rct))
	end

	def draw_polygon points, color, opacity
		name = "polygon"
		rct = [
			["points", format.coordinates(points)],
			["fill", color],
			["fill-opacity", opacity]
		]
		return format.wrap(format.build(name,rct))
	end

	def draw_wire_rect posx, posy, width, height, color
		name = "rect"
		rct = [
			["x", posx],
			["y", posy],
			["width", width],
			["height", height],
			["stroke", color],
			["stroke-width", 1],
			["fill", "none"]
		]
		return format.wrap(format.build(name,rct))
	end

	def spread_points width, height, margin, points
		pts = ""
		points.each_with_index do |point, index|
			pts += "#{margin + (index*(width-margin))/points.count} #{(height-margin)-(point*(height-margin*2))/points.max}, "
		end
		return pts
	end

end