class Nbrick

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

  def create posx, posy, width, height, bevel, bleed, chamfer, randomness
    
    rando = chamfer * randomness
    points = {
      :topleft => {
        :corner => [  posx-bleed                                  , posy-bleed                                    ],
        :bleed1 => [  posx+bevel+chamfer                          , posy-bleed                                    ],
        :bleed2 => [  posx-bleed                                  , posy+bevel+chamfer                            ],
        :edge1 =>  [  posx+bevel+chamfer                          , posy                                          ],
        :edge2 =>  [  posx                                        , posy+bevel+chamfer                            ],
        :bevel1 => [  posx+bevel+chamfer      , posy+bevel                ],
        :bevel2 => [  posx+bevel              , posy+bevel+chamfer        ]
      },      
      :topright => {      
        :corner => [  posx+width+bleed                            , posy-bleed                                    ],
        :bleed1 => [  posx+width+bleed                            , posy+bevel+chamfer                            ],
        :bleed2 => [  posx+width-bevel-chamfer                    , posy-bleed                                    ],
        :edge1 =>  [  posx+width                                  , posy+bevel+chamfer                            ],
        :edge2 =>  [  posx+width-bevel-chamfer                    , posy                                          ],
        :bevel1 => [  posx+width-bevel        , posy+bevel+chamfer      ],
        :bevel2 => [  posx+width-bevel-chamfer, posy+bevel                ]
      },
      :bottomleft => {
        :corner => [  posx-bleed                                  , posy+height+bleed                             ],
        :bleed1 => [  posx-bleed                                  , posy+height-bevel-chamfer                     ],
        :bleed2 => [  posx+bevel+chamfer                          , posy+height+bleed                             ],
        :edge1 =>  [  posx                                        , posy+height-bevel-chamfer                     ],
        :edge2 =>  [  posx+bevel+chamfer                          , posy+height                                   ],
        :bevel1 => [  posx+bevel              , posy+height-bevel-chamfer ],
        :bevel2 => [  posx+bevel+chamfer      , posy+height-bevel         ]
      },
      :bottomright => { 
        :corner => [  posx+width+bleed                            , posy+height+bleed                             ],
        :bleed1 => [  posx+width-bevel-chamfer                    , posy+height+bleed                             ],
        :bleed2 => [  posx+width+bleed                            , posy+height-bevel-chamfer                     ],
        :edge1 =>  [  posx+width-bevel-chamfer                    , posy+height                                   ],
        :edge2 =>  [  posx+width                                  , posy+height-bevel-chamfer                     ],
        :bevel1 => [  posx+width-bevel-chamfer, posy+height-bevel         ],
        :bevel2 => [  posx+width-bevel        , posy+height-bevel-chamfer ]
      }
    }

    top_left = [
      points.dig( :topleft,     :corner ),
      points.dig( :topleft,     :bleed1 ),
      points.dig( :topleft,     :edge1  ),
      points.dig( :topleft,     :bevel1 ),
      points.dig( :topleft,     :bevel2 ),
      points.dig( :topleft,     :edge2  ),
      points.dig( :topleft,     :bleed2 )
    ] 
    top_right = [ 
      points.dig( :topright,    :corner ),
      points.dig( :topright,    :bleed1 ),
      points.dig( :topright,    :edge1  ),
      points.dig( :topright,    :bevel1 ),
      points.dig( :topright,    :bevel2 ),
      points.dig( :topright,    :edge2  ),
      points.dig( :topright,    :bleed2 )
    ] 
    bottom_left = [ 
      points.dig( :bottomleft,  :corner ),
      points.dig( :bottomleft,  :bleed1 ),
      points.dig( :bottomleft,  :edge1  ),
      points.dig( :bottomleft,  :bevel1 ),
      points.dig( :bottomleft,  :bevel2 ),
      points.dig( :bottomleft,  :edge2  ),
      points.dig( :bottomleft,  :bleed2 )
    ]
    bottom_right = [
      points.dig( :bottomright, :corner ),
      points.dig( :bottomright, :bleed1 ),
      points.dig( :bottomright, :edge1  ),
      points.dig( :bottomright, :bevel1 ),
      points.dig( :bottomright, :bevel2 ),
      points.dig( :bottomright, :edge2  ),
      points.dig( :bottomright, :bleed2 )
    ]
    edge_top = [
      points.dig( :topleft,   :bleed1   ),
      points.dig( :topright,  :bleed2   ),
      points.dig( :topright,  :edge2    ),
      utils.spread_random( points.dig(:topright,:bevel2), points.dig(:topleft,:bevel1), rand(0..3), randomness ),
      points.dig( :topleft,   :edge1    )
    ]
    edge_right = [
      points.dig( :topright,    :bleed1 ),
      points.dig( :bottomright, :bleed2 ),
      points.dig( :bottomright, :edge2  ),
      utils.spread_random( points.dig(:bottomright,:bevel2), points.dig(:topright,:bevel1), rand(0..3), randomness ),
      points.dig( :topright,    :edge1  )
    ]
    edge_left = [
      points.dig( :bottomleft,  :bleed1 ),
      points.dig( :topleft,     :bleed2 ),
      points.dig( :topleft,     :edge2  ),
      utils.spread_random( points.dig(:topleft,:bevel2), points.dig(:bottomleft,:bevel1), rand(0..3), randomness ),
      points.dig( :bottomleft,  :edge1  )
    ]
    edge_bottom = [
      points.dig( :bottomright, :bleed1 ),
      points.dig( :bottomleft,  :bleed2 ),
      points.dig( :bottomleft,  :edge2  ),
      utils.spread_random( points.dig(:bottomleft,:bevel2), points.dig(:bottomright,:bevel1), rand(0..3), randomness ),
      points.dig( :bottomright, :edge1  )
    ]

    drawing = [
      draw.draw_polygon(  top_left.flatten      ,colors.up_left       ),
      draw.draw_polygon(  edge_top.flatten      ,colors.up            ),
      draw.draw_polygon(  top_right.flatten     ,colors.up_right      ),
      draw.draw_polygon(  edge_right.flatten    ,colors.right         ),
      draw.draw_polygon(  bottom_left.flatten   ,colors.down_left     ),
      draw.draw_polygon(  edge_bottom.flatten   ,colors.down          ),
      draw.draw_polygon(  bottom_right.flatten  ,colors.down_right    ),
      draw.draw_polygon(  edge_left.flatten     ,colors.left          )
    ]

    return drawing
  
  end

end