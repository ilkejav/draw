class Ggrid

	def initialize

		load "Apps/draw/svgdraw.rb"
		load "Apps/draw/colors.rb"
		load "Apps/draw/svgutils.rb"
		load "Apps/draw/svgformat.rb"
		load "Apps/draw/DLabel.rb"

		@draw = SVG_draw.new
		@colors = Colors.new
		@utils = SVG_utils.new
		@format = SVG_format.new
		@label = Dlabel.new

	end

	def draw ; return @draw end
	def colors; return @colors end
	def utils ; return @utils end
	def format ; return @format end
	def label; return @label end

	def create bounds, subX, subY, rangeX, rangeY
		drawing = []
		
		(subX+1).to_i.times do |i|

				x = utils.lerp(
					bounds[0], 
					bounds[1], 
					(i.to_f/subX.to_f)
					)
				drawing.push(
					draw.draw_polyline(
					[[x,bounds[2]],[x,bounds[3]]],
					colors.gray_darker,
					1
					))
				drawing.push(
					label.create(
						"#{(rangeX/subX)*i}",
						colors.gray_dark,
						x, bounds[3],
						12,
						"bottom",
						"dot")
					)
		end

		(subY+1).times do |i|

				y = utils.lerp(
					bounds[3], 
					bounds[2], 
					(i.to_f/subY.to_f)
					)
				drawing.push(
					draw.draw_polyline(
					[[bounds[0],y],[bounds[1],y]],
					colors.gray_darker,
					1
					))
				drawing.push(
					label.create(
						"#{(rangeY/subY)*i}",
						colors.gray_dark,
						bounds[0], y,
						12,
						"left",
						"dot")
					)
		end

		drawing.push( 
			draw.draw_wire_rect(
				bounds[0],bounds[2],bounds[1]-bounds[0],bounds[3]-bounds[2],colors.gray))

		return drawing

	end

end