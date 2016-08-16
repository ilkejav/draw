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
		drawing = []
	  drawing.push(box(512,512,256,256,32,24))
	  drawing.push(brick(256,256,256,256,32,24,24,0.2))
	  
	  drawing.unshift( draw.background(colors.normal) )
	  drawing.unshift( draw.header(width, height) )
	  drawing.push( draw.footer )
		
		return drawing.flatten
	end

	def box posx, posy, width, height, bevel, bleed
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

	def brick posx, posy, width, height, bevel, bleed, chamfer, randomness
		rando = chamfer * randomness
		points = {
			:topleft => {
				:corner => { :x => posx-bleed																		,:y => posy-bleed																		},
				:bleed1 => { :x => posx+bevel+chamfer	 													,:y => posy-bleed																		},
				:bleed2 => { :x => posx-bleed	 																	,:y => posy+bevel+chamfer														},
				:edge1 =>  { :x => posx+bevel+chamfer	 													,:y => posy 																				},
				:edge2 =>  { :x => posx	 																				,:y => posy+bevel+chamfer														},
				:bevel1 => { :x => posx+bevel+chamfer+rand(-rando..rando)				,:y => posy+bevel+rand(-rando..rando) 							},
				:bevel2 => { :x => posx+bevel+rand(-rando..rando)	 							,:y => posy+bevel+chamfer+rand(-rando..rando)				}},
			:topright => {
				:corner => { :x => posx+width+bleed	 														,:y => posy-bleed 																	},
				:bleed1 => { :x => posx+width+bleed	 														,:y => posy+bevel+chamfer														},
				:bleed2 => { :x => posx+width-bevel-chamfer											,:y => posy-bleed 																	},
				:edge1 =>  { :x => posx+width	 																	,:y => posy+bevel+chamfer														},
				:edge2 =>  { :x => posx+width-bevel-chamfer											,:y => posy 																				},
				:bevel1 => { :x => posx+width-bevel+rand(-rando..rando)	 				,:y => posy+bevel+chamfer+rand(-rando..rando)				},
				:bevel2 => { :x => posx+width-bevel-chamfer+rand(-rando..rando)	,:y => posy+bevel+rand(-rando..rando) 							}},
			:bottomleft => {
				:corner => { :x => posx-bleed	 																	,:y => posy+height+bleed 														},
				:bleed1 => { :x => posx-bleed	 																	,:y => posy+height-bevel-chamfer										},
				:bleed2 => { :x => posx+bevel+chamfer	 													,:y => posy+height+bleed 														},
				:edge1 =>  { :x => posx	 																				,:y => posy+height-bevel-chamfer 										},
				:edge2 =>  { :x => posx+bevel+chamfer	 													,:y => posy+height 																	},
				:bevel1 => { :x => posx+bevel+rand(-rando..rando)	 							,:y => posy+height-bevel-chamfer+rand(-rando..rando)},
				:bevel2 => { :x => posx+bevel+chamfer+rand(-rando..rando)	 			,:y => posy+height-bevel+rand(-rando..rando) 				}},
			:bottomright => {
				:corner => { :x => posx+width+bleed	 														,:y => posy+height+bleed 														},
				:bleed1 => { :x => posx+width-bevel-chamfer											,:y => posy+height+bleed 														},
				:bleed2 => { :x => posx+width+bleed															,:y => posy+height-bevel-chamfer										},
				:edge1 =>  { :x => posx+width-bevel-chamfer											,:y => posy+height 																	},
				:edge2 =>  { :x => posx+width	 																	,:y => posy+height-bevel-chamfer										},
				:bevel1 => { :x => posx+width-bevel-chamfer+rand(-rando..rando)	,:y => posy+height-bevel+rand(-rando..rando) 				},
				:bevel2 => { :x => posx+width-bevel+rand(-rando..rando)	 				,:y => posy+height-bevel-chamfer+rand(-rando..rando)}}
		}

		top_left = [
			points.dig(:topleft, :corner, :x)			,points.dig(:topleft, :corner, :y),
			points.dig(:topleft, :bleed1, :x)			,points.dig(:topleft, :bleed1, :y),
			points.dig(:topleft, :edge1, :x)			,points.dig(:topleft, :edge1, :y),
			points.dig(:topleft, :bevel1, :x)			,points.dig(:topleft, :bevel1, :y),
			points.dig(:topleft, :bevel2, :x)			,points.dig(:topleft, :bevel2, :y),
			points.dig(:topleft, :edge2, :x)			,points.dig(:topleft, :edge2, :y),
			points.dig(:topleft, :bleed2, :x)			,points.dig(:topleft, :bleed2, :y)
		]
		top_right = [
			points.dig(:topright, :corner, :x)		,points.dig(:topright, :corner, :y),
			points.dig(:topright, :bleed1, :x)		,points.dig(:topright, :bleed1, :y),
			points.dig(:topright, :edge1, :x)			,points.dig(:topright, :edge1, :y),
			points.dig(:topright, :bevel1, :x)		,points.dig(:topright, :bevel1, :y),
			points.dig(:topright, :bevel2, :x)		,points.dig(:topright, :bevel2, :y),
			points.dig(:topright, :edge2, :x)			,points.dig(:topright, :edge2, :y),
			points.dig(:topright, :bleed2, :x)		,points.dig(:topright, :bleed2, :y)
		]
		bottom_left = [
			points.dig(:bottomleft, :corner, :x)	,points.dig(:bottomleft, :corner, :y),
			points.dig(:bottomleft, :bleed1, :x)	,points.dig(:bottomleft, :bleed1, :y),
			points.dig(:bottomleft, :edge1, :x)		,points.dig(:bottomleft, :edge1, :y),
			points.dig(:bottomleft, :bevel1, :x)	,points.dig(:bottomleft, :bevel1, :y),
			points.dig(:bottomleft, :bevel2, :x)	,points.dig(:bottomleft, :bevel2, :y),
			points.dig(:bottomleft, :edge2, :x)		,points.dig(:bottomleft, :edge2, :y),
			points.dig(:bottomleft, :bleed2, :x)	,points.dig(:bottomleft, :bleed2, :y)
		]
		bottom_right = [
			points.dig(:bottomright, :corner, :x)	,points.dig(:bottomright, :corner, :y),
			points.dig(:bottomright, :bleed1, :x)	,points.dig(:bottomright, :bleed1, :y),
			points.dig(:bottomright, :edge1, :x)	,points.dig(:bottomright, :edge1, :y),
			points.dig(:bottomright, :bevel1, :x)	,points.dig(:bottomright, :bevel1, :y),
			points.dig(:bottomright, :bevel2, :x)	,points.dig(:bottomright, :bevel2, :y),
			points.dig(:bottomright, :edge2, :x)	,points.dig(:bottomright, :edge2, :y),
			points.dig(:bottomright, :bleed2, :x)	,points.dig(:bottomright, :bleed2, :y)
		]
		top = [
			points.dig(:topleft, :bleed1, :x)	,points.dig(:topleft, :bleed1, :y),
			points.dig(:topright, :bleed2, :x)	,points.dig(:topright, :bleed2, :y),
			points.dig(:topright, :edge2, :x)	,points.dig(:topright, :edge2, :y),
			points.dig(:topright, :bevel2, :x)	,points.dig(:topright, :bevel2, :y),
			points.dig(:topleft, :bevel1, :x)	,points.dig(:topleft, :bevel1, :y),
			points.dig(:topleft, :edge1, :x)	,points.dig(:topleft, :edge1, :y)
		]
		right = [
			points.dig(:topright, :bleed1, :x)	,points.dig(:topright, :bleed1, :y),
			points.dig(:bottomright, :bleed2, :x)	,points.dig(:bottomright, :bleed2, :y),
			points.dig(:bottomright, :edge2, :x)	,points.dig(:bottomright, :edge2, :y),
			points.dig(:bottomright, :bevel2, :x)	,points.dig(:bottomright, :bevel2, :y),
			points.dig(:topright, :bevel1, :x)	,points.dig(:topright, :bevel1, :y),
			points.dig(:topright, :edge1, :x)	,points.dig(:topright, :edge1, :y)
		]
		left = [
			points.dig(:bottomright, :bleed1, :x)	,points.dig(:bottomright, :bleed1, :y),
			points.dig(:bottomleft, :bleed2, :x)	,points.dig(:bottomleft, :bleed2, :y),
			points.dig(:bottomleft, :edge2, :x)	,points.dig(:bottomleft, :edge2, :y),
			points.dig(:bottomleft, :bevel2, :x)	,points.dig(:bottomleft, :bevel2, :y),
			points.dig(:bottomright, :bevel1, :x)	,points.dig(:bottomright, :bevel1, :y),
			points.dig(:bottomright, :edge1, :x)	,points.dig(:bottomright, :edge1, :y)
		]
		bottom = [
			points.dig(:bottomleft, :bleed1, :x)	,points.dig(:bottomleft, :bleed1, :y),
			points.dig(:topleft, :bleed2, :x)	,points.dig(:topleft, :bleed2, :y),
			points.dig(:topleft, :edge2, :x)	,points.dig(:topleft, :edge2, :y),
			points.dig(:topleft, :bevel2, :x)	,points.dig(:topleft, :bevel2, :y),
			points.dig(:bottomleft, :bevel1, :x)	,points.dig(:bottomleft, :bevel1, :y),
			points.dig(:bottomleft, :edge1, :x)	,points.dig(:bottomleft, :edge1, :y)
		]

		drawing = [
      draw.draw_polygon(top_left,colors.up_left),
      draw.draw_polygon(top,colors.up),
      draw.draw_polygon(top_right,colors.up_right),
      draw.draw_polygon(right,colors.right),
      draw.draw_polygon(bottom_left,colors.down_left),
      draw.draw_polygon(bottom,colors.down),
      draw.draw_polygon(bottom_right,colors.down_right),
      draw.draw_polygon(left,colors.left)
		]

		return drawing
	end

end