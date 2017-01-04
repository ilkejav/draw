class Nbox

	def initialize
		
		load "Apps/draw/svgdraw.rb"
		load "Apps/draw/colors.rb"
		# load "Apps/draw/svgutils.rb"

		@draw = SVG_draw.new
		# @utils = SVG_utils.new
		@colors = Colors.new

  end

  def draw ; return @draw end
	def colors; return @colors end
	# def utils ; return @utils end

  def create posx, posy, width, height, bevel, bleed

  	points = {
			:topleft => [						posx,							posy],
			:topright => [					posx+width, 			posy],
			:bottomleft => [				posx, 						posy+height],
			:bottomright => [				posx+width, 			posy+height],
			:bleedtopleft => [			posx-bleed, 			posy-bleed],
			:bleedtopright => [			posx+width+bleed, posy-bleed],
			:bleedbottomleft => [		posx-bleed, 			posy+height+bleed],
			:bleedbottomright => [	posx+width+bleed, posy+height+bleed],
			:beveltopleft => [			posx+bevel, 			posy+bevel],
			:beveltopright => [			posx+width-bevel, posy+bevel],
			:bevelbottomleft => [		posx+bevel, 			posy+height-bevel],
			:bevelbottomright => [	posx+width-bevel, posy+height-bevel],
		}

		up = [	
			points[:bleedtopleft],
			points[:bleedtopright],
			points[:topright],
			points[:beveltopright],
			points[:beveltopleft],
			points[:topleft]
		]

		right = [	
			points[:bleedtopright],
			points[:bleedbottomright],
			points[:bottomright],
			points[:bevelbottomright],
			points[:beveltopright],
			points[:topright]
		]

		down = [	
			points[:bleedbottomright],
			points[:bleedbottomleft],
			points[:bottomleft],
			points[:bevelbottomleft],
			points[:bevelbottomright],
			points[:bottomright]
		]

		left = [	
			points[:bleedbottomleft],
			points[:bleedtopleft],
			points[:topleft],
			points[:beveltopleft],
			points[:bevelbottomleft],
			points[:bottomleft]
		]
		
		drawing = [
      draw.draw_polygon(	up.flatten,			colors.up),
      draw.draw_polygon(	right.flatten,	colors.right),
      draw.draw_polygon(	down.flatten,		colors.down),
      draw.draw_polygon(	left.flatten,		colors.left)
		]

		return drawing

  end

end