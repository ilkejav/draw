require_relative("svgdraw.rb")
require_relative("colors.rb")

class Normal_map

	def initialize
		@draw = SVG_draw.new
		@colors = Colors.new
	end

	def draw ; return @draw end
	def colors; return @colors end

	def create width, height
		# drawing = [
  #       draw.header(width, height),
  #       draw.background(colors.normal),
  #       draw.draw_rect(230,145,512,256,colors.down),
  #       draw.draw_wire_rect(225,128,48,64,"white"),
  #       # draw.draw_polygon([335,345,56,123,465,32,56,234,657,23], colors.right),
  #       draw.draw_polygon([335,345,56,123,465,32,56,234,657,23], colors.right),
  #       draw.footer
  #     ]

	  drawing = brick(256,256,512,512,32,24)
	  drawing.unshift( draw.background(colors.normal) )
	  drawing.unshift( draw.header(width, height) )
	  drawing.push( draw.footer )
		
		return drawing
	end

	def brick posx, posy, width, height, bevel, bleed
		points = {
			:topleft => [posx, posy],
			:topright => [posx+width, posy],
			:bottomleft => [posx, posy+height],
			:bottomright => [posx+width, posy+height],
			:bleedtopleft => [posx-bleed, posy-bleed],
			:bleedtopright => [posx+width+bleed, posy-bleed],
			:bleedbottomleft => [posx-bleed, posy+height+bleed],
			:bleedbottomright => [posx+width+bleed, posy+height+bleed],
			:beveltopleft => [posx-bevel, posy-bevel],
			:beveltopright => [posx+width+bevel, posy-bevel],
			:bevelbottomleft => [posx-bevel, posy+height+bevel],
			:bevelbottomright => [posx+width+bevel, posy+height+bevel],
		}
		up = [	
			points[:bleedtopleft].first, points[:bleedtopleft].last,
			points[:bleedtopright].first, points[:bleedtopright].last,
			points[:topright].first, points[:topright].last,
			points[:beveltopright].first, points[:beveltopright].last,
			points[:beveltopleft].first, points[:beveltopleft].last,
			points[:topleft].first, points[:topleft].last
		]
		right = [	
			points[:bleedtopright].first, points[:bleedtopright].last,
			points[:bleedbottomright].first, points[:bleedbottomright].last,
			points[:bottomright].first, points[:bottomright].last,
			points[:bevelbottomright].first, points[:bevelbottomright].last,
			points[:beveltopright].first, points[:beveltopright].last,
			points[:topright].first, points[:topright].last
		]
		down = [	
			points[:bleedbottomright].first, points[:bleedbottomright].last,
			points[:bleedbottomleft].first, points[:bleedbottomleft].last,
			points[:bottomleft].first, points[:bottomleft].last,
			points[:bevelbottomleft].first, points[:bevelbottomleft].last,
			points[:bevelbottomright].first, points[:bevelbottomright].last,
			points[:bottomright].first, points[:bottomright].last
		]
		left = [	
			points[:bleedbottomleft].first, points[:bleedbottomleft].last,
			points[:bleedtopleft].first, points[:bleedtopleft].last,
			points[:topleft].first, points[:topleft].last,
			points[:beveltopleft].first, points[:beveltopleft].last,
			points[:bevelbottomleft].first, points[:bevelbottomleft].last,
			points[:bottomleft].first, points[:bottomleft].last
		]
		drawing = [
      draw.draw_polygon(up,colors.up),
      draw.draw_polygon(right,colors.right),
      draw.draw_polygon(down,colors.down),
      draw.draw_polygon(left,colors.left)
		]

		return drawing
	end

end