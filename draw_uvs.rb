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

			shape_info = shape.last
			
			case shape_info["type"]

			when "brick"
				drawing.push( normals.brick(
				shape_info["x"],
				shape_info["y"],
				shape_info["width"],
				shape_info["height"],
				4, # bevel
				4, # bleed
				6, # chamfer
				4))# randomness

			when "indent"
				# puts "indent"
				drawing.push( normals.indent(
				shape_info["x"],
				shape_info["y"],
				shape_info["width"],
				shape_info["height"],
				2, # bevel
				4, # bleed
				4, # bevel2
				4, # bleed2
				shape_info["direction"]))# direction

			when "corner"
				drawing.push( normals.corner(
				shape_info["x"],
				shape_info["y"],
				shape_info["width"],
				shape_info["height"],
				4, 	# bevel
				4, 	# bleed
				shape_info["sides"]))# corners

			when "plank"
				drawing.push( normals.plank(
				shape_info["x"],
				shape_info["y"],
				shape_info["width"],
				shape_info["height"],
				shape_info["direction"],
				8, 	# bevel
				0, 	# bleed
				8))	# randomness

			else
				drawing.push( normals.box(
				shape_info["x"],
				shape_info["y"],
				shape_info["width"],
				shape_info["height"],
				4, 	# bevel
				4)) # bleed
			end

			drawing.push( draw.draw_text(
				"#{shape.first}", 
				"black", 
				shape_info["x"] + shape_info["width"]/2,
				shape_info["y"] + shape_info["height"]/2))
			
		end

		drawing.unshift( draw.background(colors.normal) )
		drawing.unshift( draw.header(width, height) )
		drawing.push( draw.footer )
			
		return drawing.flatten
	end

end