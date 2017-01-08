class Bounds

  def initialize rect, rangeX, rangeY
    load "Apps/draw/svgutils.rb"
    @utils = SVG_utils.new

    @rect = rect
    @rangeX = rangeX
    @rangeY = rangeY
  end

  def utils ; return @utils end

  def rect ; return @rect end
  def width ; return rect.last[0] - rect.first[0] end
  def height ; return rect.last[1] - rect.first[1] end
  def left ; return rect.first[0] end
  def right ; return rect.last[0] end
  def top ; return rect.first[1] end
  def bottom ; return rect.last[1] end

  def rangeX ; return @rangeX end
  def rangeY ; return @rangeY end

  # def
  # end

  def lerp_horizontal x
    return utils.lerp(left, right, x)
  end

  def lerp_vertical y
    return utils.lerp(bottom, top, y)
  end

  def lerp_range x, y
    return [ utils.lerp(left,right,x.to_f/rangeX).to_f, utils.lerp(bottom,top,y.to_f/rangeY).to_f ]
  end

  def locate_horizontal x
    return utils.lerp(left, right, x.to_f/rangeX) 
  end

  def locate_horizontal_special x
    return utils.lerp(left, right, x.to_f/(rangeX-1)) 
  end

  def locate_vertical y
    return utils.lerp(bottom, top, y.to_f/rangeY) 
  end

  # def get_value_at_x 
  #   return utils.
  # end

  # def get_value_at_y

  # end

  # def get_values_at

  # end

end