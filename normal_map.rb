class Normal_map

	def initialize

		load "Apps/draw/svgdraw.rb"
		load "Apps/draw/svgutils.rb"
		load "Apps/draw/colors.rb"
		@draw = SVG_draw.new
		@utils = SVG_utils.new
		@colors = Colors.new
		
	end

	def draw ; return @draw end
	def utils ; return @utils end
	def colors; return @colors end

	def box posx, posy, width, height, bevel, bleed

		load "Apps/draw/normals/Nbox.rb"
		drawing = Nbox.new
		return drawing.create(posx, posy, width, height, bevel, bleed)

	end

	def brick posx, posy, width, height, bevel, bleed, chamfer, randomness
		
		rando = chamfer * randomness
		points = {
			:topleft => {
				:corner => [	posx-bleed																	,	posy-bleed 																		],
				:bleed1 => [	posx+bevel+chamfer	 												,	posy-bleed																		],
				:bleed2 => [	posx-bleed	 																,	posy+bevel+chamfer														],
				:edge1 =>  [	posx+bevel+chamfer	 												,	posy 																					],
				:edge2 =>  [	posx	 																			,	posy+bevel+chamfer														],
				:bevel1 => [	posx+bevel+chamfer			,	posy+bevel 								],
				:bevel2 => [	posx+bevel	 						,	posy+bevel+chamfer				]
			},			
			:topright => {			
				:corner => [	posx+width+bleed	 													,	posy-bleed 																		],
				:bleed1 => [	posx+width+bleed	 													,	posy+bevel+chamfer														],
				:bleed2 => [	posx+width-bevel-chamfer										,	posy-bleed 																		],
				:edge1 =>  [	posx+width	 																,	posy+bevel+chamfer														],
				:edge2 =>  [	posx+width-bevel-chamfer										,	posy 																					],
				:bevel1 => [	posx+width-bevel	 			,	posy+bevel+chamfer			],
				:bevel2 => [	posx+width-bevel-chamfer,	posy+bevel								]
			},
			:bottomleft => {
				:corner => [	posx-bleed	 																,	posy+height+bleed 														],
				:bleed1 => [	posx-bleed	 																,	posy+height-bevel-chamfer											],
				:bleed2 => [	posx+bevel+chamfer	 												,	posy+height+bleed 														],
				:edge1 =>  [	posx	 																			,	posy+height-bevel-chamfer 										],
				:edge2 =>  [	posx+bevel+chamfer	 												,	posy+height 																	],
				:bevel1 => [	posx+bevel	 						,	posy+height-bevel-chamfer	],
				:bevel2 => [	posx+bevel+chamfer	 		,	posy+height-bevel 				]
			},
			:bottomright => {	
				:corner => [	posx+width+bleed	 													,	posy+height+bleed 														],
				:bleed1 => [	posx+width-bevel-chamfer										,	posy+height+bleed 														],
				:bleed2 => [	posx+width+bleed														,	posy+height-bevel-chamfer											],
				:edge1 =>  [	posx+width-bevel-chamfer										,	posy+height 																	],
				:edge2 =>  [	posx+width	 																,	posy+height-bevel-chamfer											],
				:bevel1 => [	posx+width-bevel-chamfer,	posy+height-bevel 				],
				:bevel2 => [	posx+width-bevel	 			,	posy+height-bevel-chamfer	]
			}
		}

		top_left = [
			points.dig(	:topleft,			:corner	),
			points.dig(	:topleft,			:bleed1	),
			points.dig(	:topleft,			:edge1	),
			points.dig(	:topleft,			:bevel1	),
			points.dig(	:topleft,			:bevel2	),
			points.dig(	:topleft,			:edge2	),
			points.dig(	:topleft,			:bleed2	)
		]	
		top_right = [	
			points.dig(	:topright, 		:corner	),
			points.dig(	:topright, 		:bleed1	),
			points.dig(	:topright, 		:edge1	),
			points.dig(	:topright, 		:bevel1	),
			points.dig(	:topright, 		:bevel2	),
			points.dig(	:topright, 		:edge2	),
			points.dig(	:topright, 		:bleed2	)
		]	
		bottom_left = [	
			points.dig(	:bottomleft, 	:corner	),
			points.dig(	:bottomleft, 	:bleed1	),
			points.dig(	:bottomleft, 	:edge1	),
			points.dig(	:bottomleft, 	:bevel1	),
			points.dig(	:bottomleft, 	:bevel2	),
			points.dig(	:bottomleft, 	:edge2	),
			points.dig(	:bottomleft, 	:bleed2	)
		]
		bottom_right = [
			points.dig(	:bottomright, :corner	),
			points.dig(	:bottomright, :bleed1	),
			points.dig(	:bottomright, :edge1	),
			points.dig(	:bottomright, :bevel1	),
			points.dig(	:bottomright, :bevel2	),
			points.dig(	:bottomright, :edge2	),
			points.dig(	:bottomright, :bleed2	)
		]
		edge_top = [
			points.dig(	:topleft, 	:bleed1		),
			points.dig(	:topright, 	:bleed2		),
			points.dig(	:topright, 	:edge2		),
			utils.spread_random( points.dig(:topright,:bevel2), points.dig(:topleft,:bevel1), rand(0..3), randomness ),
			points.dig(	:topleft, 	:edge1		)
		]
		edge_right = [
			points.dig(	:topright, 		:bleed1	),
			points.dig(	:bottomright, :bleed2	),
			points.dig(	:bottomright, :edge2	),
			utils.spread_random( points.dig(:bottomright,:bevel2), points.dig(:topright,:bevel1), rand(0..3), randomness ),
			points.dig(	:topright, 		:edge1	)
		]
		edge_left = [
			points.dig(	:bottomleft, 	:bleed1	),
			points.dig(	:topleft, 		:bleed2	),
			points.dig(	:topleft, 		:edge2	),
			utils.spread_random( points.dig(:topleft,:bevel2), points.dig(:bottomleft,:bevel1), rand(0..3), randomness ),
			points.dig(	:bottomleft, 	:edge1	)
		]
		edge_bottom = [
			points.dig(	:bottomright, :bleed1	),
			points.dig(	:bottomleft, 	:bleed2	),
			points.dig(	:bottomleft, 	:edge2	),
			utils.spread_random( points.dig(:bottomleft,:bevel2), points.dig(:bottomright,:bevel1), rand(0..3), randomness ),
			points.dig(	:bottomright, :edge1	)
		]

		drawing = [
      draw.draw_polygon(	top_left.flatten			,colors.up_left				),
      draw.draw_polygon(	edge_top.flatten			,colors.up						),
      draw.draw_polygon(	top_right.flatten			,colors.up_right			),
      draw.draw_polygon(	edge_right.flatten		,colors.right					),
      draw.draw_polygon(	bottom_left.flatten		,colors.down_left			),
      draw.draw_polygon(	edge_bottom.flatten		,colors.down					),
      draw.draw_polygon(	bottom_right.flatten	,colors.down_right		),
      draw.draw_polygon(	edge_left.flatten			,colors.left					)
		]

		return drawing
	end

	def indent posx, posy, width, height, bevel, bleed, bevel2, bleed2, direction
		points = {
			:topleft => [						posx,							posy 							],
			:topright => [					posx+width, 			posy 							],
			:bottomleft => [				posx, 						posy+height 			],
			:bottomright => [				posx+width, 			posy+height 			],
			:bleedtopleft => [			posx-bleed, 			posy-bleed				],
			:bleedtopright => [			posx+width+bleed, posy-bleed				],
			:bleedbottomleft => [		posx-bleed, 			posy+height+bleed ],
			:bleedbottomright => [	posx+width+bleed, posy+height+bleed ],
			:beveltopleft => [			posx+bevel, 			posy+bevel 				],
			:beveltopright => [			posx+width-bevel, posy+bevel 				],
			:bevelbottomleft => [		posx+bevel, 			posy+height-bevel ],
			:bevelbottomright => [	posx+width-bevel, posy+height-bevel ],
		}
		case direction
			when "up"
				points[:bleedtopleft] = [ 		posx-bleed, 				posy+bevel2  				]
				points[:bleedtopright] = [ 		posx+width+bleed, 	posy+bevel2   				]
				points[:beveltopleft] = [			posx+bevel, 				posy-bleed2 				]
				points[:beveltopright] = [ 		posx+width-bevel, 	posy-bleed2 				]
			when "right"
				points[:bleedtopright] = [ 		posx+width-bevel2, 	posy-bleed 				]
				points[:bleedbottomright] = [ posx+width-bevel2, 	posy+height+bleed 	]
				points[:beveltopright] = [ 		posx+width+bleed2, 	posy+bevel 				]
				points[:bevelbottomright] = [ posx+width+bleed2, 	posy+height-bevel 	]
			when "down"
				points[:bleedbottomleft] = [ 	posx-bleed, 				posy+height-bleed2 	]
				points[:bleedbottomright] = [ posx+width+bleed, 	posy+height-bleed2 	]
				points[:bevelbottomleft] = [ 	posx+bevel, 				posy+height+bevel2 	]
				points[:bevelbottomright] = [ posx+width-bevel, 	posy+height+bevel2 	]
			when "left"
				points[:bleedtopleft] = [ 		posx+bevel2, 				posy-bleed 					]
				points[:bleedbottomleft] = [ 	posx+bevel2, 				posy+height+bleed 	]
				points[:beveltopleft] = [ 		posx-bleed2, 				posy+bevel 					]
				points[:bevelbottomleft] = [ 	posx-bleed2, 				posy+height-bevel 	]
		end

		bg = [
			points[:beveltopleft],
			points[:beveltopright],
			points[:bevelbottomright],
			points[:bevelbottomleft]
		]
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
    
    drawing = []
    drawing.push( draw.draw_polygon(	bg,			colors.normal 		) )
    drawing.push( draw.draw_polygon(	up,			colors.down 		) ) unless direction.match "up"
    drawing.push( draw.draw_polygon(	right,	colors.left 	) )	unless direction.match "right"
    drawing.push( draw.draw_polygon(	down,		colors.up 	) )	unless direction.match "down"
    drawing.push( draw.draw_polygon(	left,		colors.right 	) )	unless direction.match "left"

		return drawing
	
	end

	def corner posx, posy, width, height, bevel, bleed, sides
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
      draw.draw_polygon(	up,			((sides[0] == 1) ? colors.up 		: colors.down		) ),
      draw.draw_polygon(	right,	((sides[1] == 1) ? colors.right 	: colors.left	) ),
      draw.draw_polygon(	down,		((sides[2] == 1) ? colors.down 	: colors.up			) ),
      draw.draw_polygon(	left,		((sides[3] == 1) ? colors.left 	: colors.right	) )
		]

		return drawing
	end

	def plank posx, posy, width, height, direction, bevel, bleed, randomness

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

		edges = {
			:top => [ 		posx, posy, 									posx + width, posy 					],
			:right => [ 	posx + width, posy, 					posx + width, posy + height ],
			:bottom => [	posx + width, posy + height, 	posx, posy + height 				],
			:left => [ 		posx, posy + height, 					posx, posy]
		}
		
		up = [	
			points[:bleedtopleft],
			points[:bleedtopright],
			points[:topright],
			utils.spread_random( points[:beveltopright], points[:beveltopleft], rand(1..5), randomness ),
			points[:topleft]
		]
		right = [	
			points[:bleedtopright],
			points[:bleedbottomright],
			points[:bottomright],
			utils.spread_random( points[:bevelbottomright], points[:beveltopright], rand(1..5), randomness ),
			points[:topright]
		]
		down = [	
			points[:bleedbottomright],
			points[:bleedbottomleft],
			points[:bottomleft],
			utils.spread_random( points[:bevelbottomleft], points[:bevelbottomright], rand(1..5), randomness ),
			points[:bottomright]
		]
		left = [	
			points[:bleedbottomleft],
			points[:bleedtopleft],
			points[:topleft],
			utils.spread_random( points[:beveltopleft], points[:bevelbottomleft], rand(1..5), randomness ),
			points[:bottomleft]
		]

		drawing = []
			
		drawing = [
      draw.draw_polygon(	up.flatten,			colors.up),
      draw.draw_polygon(	right.flatten,	colors.right),
      draw.draw_polygon(	down.flatten,		colors.down),
      draw.draw_polygon(	left.flatten,		colors.left)
		]
		
		case direction
		when "vertical"
			rand(1..4).times do
				pos = utils.lerp_2d(	points[:beveltopleft],	points[:beveltopright],	rand(0.0..1.0)	)
				drawing.push( 
					crack( pos[0].to_i, pos[1].to_i, (height*rand(0.1..0.5)).to_i, rand(2..8.0), "down", 4 )
					)
			end
			rand(1..4).times do
				pos = utils.lerp_2d(	points[:bevelbottomleft],	points[:bevelbottomright],	rand(0.0..1.0)	)
				drawing.push( 
					crack( pos[0].to_i, pos[1].to_i, (height*rand(0.1..0.5)).to_i, rand(2..8.0), "up", 4 )
					)
		end
		
		when "horizontal"
			rand(1..4).times do
				pos = utils.lerp_2d(	points[:beveltopleft],	points[:bevelbottomleft],	rand(0.0..1.0)	)
				drawing.push( 
					crack( pos[0].to_i, pos[1].to_i, (width*rand(0.1..0.5)).to_i, rand(2..8.0), "right", 4 )
					)
			end
			rand(1..4).times do
				pos = utils.lerp_2d(	points[:beveltopright],	points[:bevelbottomright],	rand(0.0..1.0)	)
				drawing.push( 
					crack( pos[0].to_i, pos[1].to_i, (width*rand(0.1..0.5)).to_i, rand(2..8.0), "left", 4 )
					)
			end
		end

		return drawing
	end

	def crack posx, posy, length, width, direction, randomness

		points = {
			:start => 		[	posx + width, 					posy					],
			:end =>				[	posx + width - length, 	posy 					],
			:edge1 =>			[	posx + width, 					posy + width	],
			:edge2 =>			[	posx + width, 					posy - width	]
		}
		color1 = colors.up
		color2 = colors.down

		case direction
		when "up"
			points = {
				:start => 	[	posx, 					posy						],
				:end =>			[	posx, 					posy - length	],
				:edge1 =>		[	posx - width, 	posy 					],
				:edge2 =>		[	posx + width, 	posy 					]
			}
			color1 = colors.right
			color2 = colors.left

		when "right"
			points = {
				:start => 	[	posx, 					posy					],
				:end =>			[	posx + length, 	posy 					],
				:edge1 =>		[	posx, 					posy + width		],
				:edge2 =>		[	posx, 					posy - width		]
			}
			color1 = colors.up
			color2 = colors.down

		when "down"
			points = {
				:start => 	[	posx, 					posy					],
				:end =>			[	posx, 					posy + length	],
				:edge1 =>		[	posx + width, 	posy 					],
				:edge2 =>		[	posx - width, 	posy 					]
			}
			color1 = colors.left
			color2 = colors.right

		when "left"
			# do nothing because points{} is already configured
		end

		subdiv = rand(1..5)
		seed = rand(0..1000)
		
		middle_edge = utils.spread_random( points[:end], points[:start], subdiv, 0)
		
		edge1 = utils.spread_random( points[:edge1], points[:end], subdiv, 0),
		
		edge2 = utils.spread_random( points[:edge2], points[:end], subdiv, 0),
		
		side1 = [
			edge1,
			middle_edge
		]

		side2 = [
			edge2,
			middle_edge
		]

		drawing = [
			# draw.draw_polygon(	side1.flatten,	color1	),
      draw.draw_polygon(	side2.flatten,	color2	)
		]

		return drawing
	end

end