class Nplank

	def initialize

    load "Apps/draw/svgdraw.rb"
    load "Apps/draw/colors.rb"
    load "Apps/draw/svgutils.rb"
    load "Apps/draw/normals/Ncrack.rb"

    @draw = SVG_draw.new
    @utils = SVG_utils.new
    @colors = Colors.new
    @crack = Ncrack.new

	end

  def draw ; return @draw end
  def colors; return @colors end
  def utils ; return @utils end
  def crack ; return @crack end

	def create posx, posy, width, height, direction, bevel, bleed, randomness
    
    points = {
      :topleft => [           posx,             posy],
      :topright => [          posx+width,       posy],
      :bottomleft => [        posx,             posy+height],
      :bottomright => [       posx+width,       posy+height],
      :bleedtopleft => [      posx-bleed,       posy-bleed],
      :bleedtopright => [     posx+width+bleed, posy-bleed],
      :bleedbottomleft => [   posx-bleed,       posy+height+bleed],
      :bleedbottomright => [  posx+width+bleed, posy+height+bleed],
      :beveltopleft => [      posx+bevel,       posy+bevel],
      :beveltopright => [     posx+width-bevel, posy+bevel],
      :bevelbottomleft => [   posx+bevel,       posy+height-bevel],
      :bevelbottomright => [  posx+width-bevel, posy+height-bevel],
    }

    edges = {
      :top => [     posx, posy,                   posx + width, posy          ],
      :right => [   posx + width, posy,           posx + width, posy + height ],
      :bottom => [  posx + width, posy + height,  posx, posy + height         ],
      :left => [    posx, posy + height,          posx, posy]
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
      draw.draw_polygon(  up.flatten,     colors.up),
      draw.draw_polygon(  right.flatten,  colors.right),
      draw.draw_polygon(  down.flatten,   colors.down),
      draw.draw_polygon(  left.flatten,   colors.left)
    ]
    
    case direction
    when "vertical"
      rand(1..4).times do
        pos = utils.lerp_2d(  points[:beveltopleft],  points[:beveltopright], rand(0.0..1.0)  )
        drawing.push( 
          crack.create( pos[0].to_i, pos[1].to_i, (height*rand(0.1..0.5)).to_i, rand(2..8.0), "down", 4 )
          )
      end
      rand(1..4).times do
        pos = utils.lerp_2d(  points[:bevelbottomleft], points[:bevelbottomright],  rand(0.0..1.0)  )
        drawing.push( 
          crack.create( pos[0].to_i, pos[1].to_i, (height*rand(0.1..0.5)).to_i, rand(2..8.0), "up", 4 )
          )
    end
    
    when "horizontal"
      rand(1..4).times do
        pos = utils.lerp_2d(  points[:beveltopleft],  points[:bevelbottomleft], rand(0.0..1.0)  )
        drawing.push( 
          crack.create( pos[0].to_i, pos[1].to_i, (width*rand(0.1..0.5)).to_i, rand(2..8.0), "right", 4 )
          )
      end
      rand(1..4).times do
        pos = utils.lerp_2d(  points[:beveltopright], points[:bevelbottomright],  rand(0.0..1.0)  )
        drawing.push( 
          crack.create( pos[0].to_i, pos[1].to_i, (width*rand(0.1..0.5)).to_i, rand(2..8.0), "left", 4 )
          )
      end
    end

    return drawing

	end

end