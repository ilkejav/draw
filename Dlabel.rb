class Dlabel

	def initialize
		load "Apps/draw/svgdraw.rb"
		load "Apps/draw/colors.rb"

		@draw = SVG_draw.new
		@colors = Colors.new
	end

	def draw ; return @draw end
	def colors; return @colors end

	def create text, color, posX, posY, size, alignment, style
		drawing = []

		case style
		when "dot"
			drawing.push(
				draw.draw_circle(posX, posY, 1.5, color))
		when "circle_dot"
			drawing.push(
				draw.draw_circle(posX, posY, 3, color))
			drawing.push(
				draw.draw_circle(posX, posY, 2, colors.gray_darkest))
		when "plain"
			
		end

		case alignment
		when "left"
			drawing.push(
				draw.draw_text(text, color, posX - 8, posY, size, "end"))

		when "right"
			drawing.push(
				draw.draw_text(text, color, posX + 8, posY, size, "start"))

		when "top"
			drawing.push(
				draw.draw_text(text, color, posX, posY - 8, size, "middle"))

		when "bottom"
			drawing.push(
				draw.draw_text(text, color, posX, posY + 8, size, "middle"))
			
		end

		return drawing
	end

end