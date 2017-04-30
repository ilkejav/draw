class Gline

	def initialize
		load "Apps/draw/svgdraw.rb"
		load "Apps/draw/svgutils.rb"
		load "Apps/draw/colors.rb"
		load "Apps/draw/graph/Gbounds.rb"
		@draw = SVG_draw.new
		@utils = SVG_utils.new
		@colors = Colors.new
	end

	def draw ; return @draw end
	def utils ; return @utils end
	def colors; return @colors end

	def create bounds, data, color, value_count, max_value, start, style
		
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

		case style

		when "plain"	
			drawing = [
				draw.draw_polyline( points, colors.gray_darkest, 3),
				draw.draw_polyline( points, color, 1)]

		when "filled"
			drawing = []
			drawing.push(
				draw.draw_polyline( points, color, 1)
				)

			points.push( [points.flatten[-2], range.bottom] ) # for some reason points is super deep and I need to flatten it. Should investigate
			points.push( [range.left + start, range.bottom] )
			points.push( points.first )

			drawing.push(
				draw.draw_polygon( points.flatten, color, 0.1)
				)
			# drawing = [
			# 	draw.draw_polyline( points, color, 1),
			# 	draw.draw_polygon( points.flatten, color, 0.1)]
		
		end
			

		return drawing

	end

end