class Ncrack

	def initialize

    load "Apps/draw/svgdraw.rb"
    load "Apps/draw/colors.rb"
    load "Apps/draw/svgutils.rb"

    @draw = SVG_draw.new
    @utils = SVG_utils.new
    @colors = Colors.new

	end

  def draw ; return @draw end
  def colors; return @colors end
  def utils ; return @utils end

	def create posx, posy, length, width, direction, randomness

    points = {
      :start =>     [ posx + width,           posy          ],
      :end =>       [ posx + width - length,  posy          ],
      :edge1 =>     [ posx + width,           posy + width  ],
      :edge2 =>     [ posx + width,           posy - width  ]
    }
    color1 = colors.up
    color2 = colors.down

    case direction
    when "up"
      points = {
        :start =>   [ posx,           posy            ],
        :end =>     [ posx,           posy - length ],
        :edge1 =>   [ posx - width,   posy          ],
        :edge2 =>   [ posx + width,   posy          ]
      }
      color1 = colors.right
      color2 = colors.left

    when "right"
      points = {
        :start =>   [ posx,           posy          ],
        :end =>     [ posx + length,  posy          ],
        :edge1 =>   [ posx,           posy + width    ],
        :edge2 =>   [ posx,           posy - width    ]
      }
      color1 = colors.up
      color2 = colors.down

    when "down"
      points = {
        :start =>   [ posx,           posy          ],
        :end =>     [ posx,           posy + length ],
        :edge1 =>   [ posx + width,   posy          ],
        :edge2 =>   [ posx - width,   posy          ]
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
      # draw.draw_polygon(  side1.flatten,  color1  ),
      draw.draw_polygon(  side2.flatten,  color2  )
    ]

    return drawing
	
  end

end