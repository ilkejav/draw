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

	def create width, height, margin, subX, subY, rangeX, rangeY
		drawing = []
		
		(subX+1).to_i.times do |i|

				x = utils.lerp(
					margin, 
					width-margin, 
					(i.to_f/subX.to_f)
					)
				drawing.push(
					draw.draw_polyline(
					[[x,margin],[x,height-margin]],
					colors.gray_darker,
					1
					))
				drawing.push(
					label.create(
						"#{(rangeX/subX)*i}",
						colors.gray_dark,
						x, height-margin,
						12,
						"bottom")
					)
		end

		(subY+1).times do |i|

				y = utils.lerp(
					height-margin, 
					margin, 
					(i.to_f/subY.to_f)
					)
				drawing.push(
					draw.draw_polyline(
					[[margin,y],[width-margin,y]],
					colors.gray_darker,
					1
					))
				drawing.push(
					label.create(
						"#{(rangeY/subY)*i}",
						colors.gray_dark,
						margin, y,
						12,
						"left")
					)
		end

		drawing.push( 
			draw.draw_wire_rect(
				margin,margin,width-margin*2,height-margin*2,colors.gray))

		return drawing

	end

end