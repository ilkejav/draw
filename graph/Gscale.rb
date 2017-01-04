class Gscale

	def initialize

		load "Apps/draw/svgdraw.rb"
		load "Apps/draw/colors.rb"
		load "Apps/draw/svgutils.rb"

		@draw = SVG_draw.new
		@utils = SVG_utils.new
		@colors = Colors.new

	end

	def create
		drawing = []
		# payload
		return drawing
	end

end