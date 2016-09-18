class Nindent

  def initialize

    load "Apps/draw/svgdraw.rb"
    load "Apps/draw/colors.rb"
    load "Apps/draw/svgutils.rb"

    @draw = SVG_draw.new
    @utils = SVG_utils.new
    @colors = Colors.new

  end

  def draw ; return @draw end
  def colors ; return @colors end
  def utils ; return @utils end

  def create posx, posy, width, height, bevel, bleed, bevel2, bleed2, direction
    # puts "Nindent"
    points = {
      :topleft => [           posx,             posy              ],
      :topright => [          posx+width,       posy              ],
      :bottomleft => [        posx,             posy+height       ],
      :bottomright => [       posx+width,       posy+height       ],
      :bleedtopleft => [      posx-bleed,       posy-bleed        ],
      :bleedtopright => [     posx+width+bleed, posy-bleed        ],
      :bleedbottomleft => [   posx-bleed,       posy+height+bleed ],
      :bleedbottomright => [  posx+width+bleed, posy+height+bleed ],
      :beveltopleft => [      posx+bevel,       posy+bevel        ],
      :beveltopright => [     posx+width-bevel, posy+bevel        ],
      :bevelbottomleft => [   posx+bevel,       posy+height-bevel ],
      :bevelbottomright => [  posx+width-bevel, posy+height-bevel ],
    }
    case direction
      when "up"
        points[:bleedtopleft] = [     posx-bleed,         posy+bevel2         ]
        points[:bleedtopright] = [    posx+width+bleed,   posy+bevel2           ]
        points[:beveltopleft] = [     posx+bevel,         posy-bleed2         ]
        points[:beveltopright] = [    posx+width-bevel,   posy-bleed2         ]
      when "right"
        points[:bleedtopright] = [    posx+width-bevel2,  posy-bleed        ]
        points[:bleedbottomright] = [ posx+width-bevel2,  posy+height+bleed   ]
        points[:beveltopright] = [    posx+width+bleed2,  posy+bevel        ]
        points[:bevelbottomright] = [ posx+width+bleed2,  posy+height-bevel   ]
      when "down"
        points[:bleedbottomleft] = [  posx-bleed,         posy+height-bleed2  ]
        points[:bleedbottomright] = [ posx+width+bleed,   posy+height-bleed2  ]
        points[:bevelbottomleft] = [  posx+bevel,         posy+height+bevel2  ]
        points[:bevelbottomright] = [ posx+width-bevel,   posy+height+bevel2  ]
      when "left"
        points[:bleedtopleft] = [     posx+bevel2,        posy-bleed          ]
        points[:bleedbottomleft] = [  posx+bevel2,        posy+height+bleed   ]
        points[:beveltopleft] = [     posx-bleed2,        posy+bevel          ]
        points[:bevelbottomleft] = [  posx-bleed2,        posy+height-bevel   ]
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
    drawing.push( draw.draw_polygon(  bg.flatten,     colors.normal     ) )
    drawing.push( draw.draw_polygon(  up.flatten,     colors.down     ) ) unless direction.match "up"
    drawing.push( draw.draw_polygon(  right.flatten,  colors.left   ) ) unless direction.match "right"
    drawing.push( draw.draw_polygon(  down.flatten,   colors.up   ) ) unless direction.match "down"
    drawing.push( draw.draw_polygon(  left.flatten,   colors.right  ) ) unless direction.match "left"

    # p drawing
    return drawing
  
  end

end