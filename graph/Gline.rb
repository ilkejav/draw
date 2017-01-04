class Gline

	def initialize

		load "Apps/draw/svgdraw.rb"
		load "Apps/draw/svgutils.rb"
		load "Apps/draw/colors.rb"
		# load "Apps/draw/svgformat.rb"

		@draw = SVG_draw.new
		@utils = SVG_utils.new
		@colors = Colors.new
		# @format = SVG_format.new

	end

	def draw ; return @draw end
	def utils ; return @utils end
	def colors; return @colors end
	# def format ; return @format end

	def create width, height, data, color, value_count, max_value, margin
		
		points = [utils.spread_points(width - margin*2, height - margin*2, margin, margin, value_count, max_value, data)]

		drawing = [
			draw.draw_polyline( points, colors.gray_darkest, 3),
			draw.draw_polyline( points, color, 1)
		]

		return drawing

	end

end