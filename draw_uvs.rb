require_relative "svgdraw.rb"
require_relative "svgutils.rb"
require_relative "normal_map.rb"
require_relative "colors.rb"
require "json"

class Draw_Uvs
	def initialize
		@draw = SVG_draw.new
		@utils = SVG_utils.new
		@normals = Normal_map.new
    @colors = Colors.new
	end

	def draw ; return @draw end
	def utils ; return @utils end
	def normals ; return @normals end
	def colors; return @colors end

	def create width, height, path, file
		drawing = []

		shapes = JSON.load( File.new("#{path}/#{file}", 'r') )

		shapes.each do |shape|

			s = shape.last
			
			case s["type"]

			when "brick"
				drawing.push( normals.brick(
					s["x"],
					s["y"],
					s["width"],
					s["height"],
					4, # bevel
					4, # bleed
					6, # chamfer
					4))# randomness

			when "indent"
				# puts "indent"
				drawing.push( normals.indent(
					s["x"],
					s["y"],
					s["width"],
					s["height"],
					2, # bevel
					4, # bleed
					4, # bevel2
					4, # bleed2
					s["direction"]))# direction

			when "corner"
				drawing.push( normals.corner(
					s["x"],
					s["y"],
					s["width"],
					s["height"],
					4, 	# bevel
					4, 	# bleed
					s["sides"]))# corners

			when "plank"
				drawing.push( normals.plank(
					s["x"],
					s["y"],
					s["width"],
					s["height"],
					s["direction"],
					8, 	# bevel
					0, 	# bleed
					8))	# randomness

			else
				drawing.push( normals.box(
					s["x"],
					s["y"],
					s["width"],
					s["height"],
					4, 	# bevel
					4)) # bleed
			end

			drawing.push( draw.draw_text(
				"#{shape.first}", 
				"black", 
				s["x"] + s["width"]/2,
				s["y"] + s["height"]/2))
			
		end

		drawing.unshift( draw.background(colors.normal) )
		drawing.unshift( draw.header(width, height) )
		drawing.push( draw.footer )
			
		return drawing.flatten
	end

end