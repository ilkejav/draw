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
		# @content = File.new('Apps\draw\svg_read.json', 'r')
  #   @shapes = JSON.load(@content)
    @colors = Colors.new
	end

	def draw ; return @draw end
	def utils ; return @utils end
	def normals ; return @normals end
	# def content; return @content end
	# def shapes; return @shapes end
	def colors; return @colors end

	def create width, height, path, file
		drawing = []

		shapes = JSON.load( File.new("#{path}/#{file}", 'r') )

		shapes.each do |shape|

			case shape.last["type"]

			when "brick"
				drawing.push( normals.brick(
				shape.last["x"],
				shape.last["y"],
				shape.last["width"],
				shape.last["height"],
				4, # bevel
				4, # bleed
				6, # chamfer
				4))# randomness
			when "indent"
				# puts "indent"
				drawing.push( normals.indent(
				shape.last["x"],
				shape.last["y"],
				shape.last["width"],
				shape.last["height"],
				2, # bevel
				2, # bleed
				4, # bevel2
				4, # bleed2
				shape.last["direction"]))# direction
			else
				drawing.push( normals.box(
				shape.last["x"],
				shape.last["y"],
				shape.last["width"],
				shape.last["height"],
				4, # bevel
				4))# randomness
			end

			drawing.push( draw.draw_text(
				"#{shape.first}", 
				"white", 
				shape.last["x"] + shape.last["width"]/2,
				shape.last["y"] + shape.last["height"]/2))

		end

		drawing.unshift( draw.background(colors.normal) )
		drawing.unshift( draw.header(width, height) )
		drawing.push( draw.footer )
			
		return drawing.flatten
	end

end