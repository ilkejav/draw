class Gline

	def initialize

		load "Apps/draw/svgdraw.rb"
		load "Apps/draw/svgutils.rb"
		load "Apps/draw/colors.rb"
		# load "Apps/draw/svgformat.rb"
		load "Apps/draw/graph/Gbounds.rb"

		@draw = SVG_draw.new
		@utils = SVG_utils.new
		@colors = Colors.new
		# @format = SVG_format.new

	end

	def draw ; return @draw end
	def utils ; return @utils end
	def colors; return @colors end
	# def format ; return @format end

	def create bounds, data, color, value_count, max_value, start
		
		range = bounds

		points = [
			utils.spread_points(
				range.width, 
				range.height, 
				range.left + start, 
				range.top, 
				range.rangeX, 
				range.rangeY, 
				data)]

		drawing = [
			draw.draw_polyline( points, colors.gray_darkest, 3),
			draw.draw_polyline( points, color, 1)
		]

		return drawing

	end

end