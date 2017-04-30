class Bounds

  def initialize width, height, margins, rangeX, rangeY, offset
    load "Apps/draw/svgutils.rb"
    @utils = SVG_utils.new
    @canvas = [width,height]
    @rect = [
      [offset[0] + margins[0], offset[1] + margins[2]],
      [offset[0] + width - margins[1], offset[1] + height - margins[3]]]
    @rangeX = rangeX
    @rangeY = rangeY
    @offset = offset
  end

  def utils ; return @utils end
  def rect ; return @rect end
  def canvas ; return @canvas end
  def width ; return rect.last[0] - rect.first[0] end
  def height ; return rect.last[1] - rect.first[1] end
  def left ; return rect.first[0] end
  def right ; return rect.last[0] end
  def top ; return rect.first[1] end
  def bottom ; return rect.last[1] end
  def margins ;  return [left, right, top, bottom] end
  def offset ; return @offset end
  def rangeX ; return @rangeX end
  def rangeY ; return @rangeY end

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
  # end

  # def get_value_at_y
  # end

  # def get_values_at
  # end

  def divide_vertical ratio, margin, leftRangeX, leftRangeY, rightRangeX, rightRangeY

    # puts("#{left} #{right} #{top} #{bottom}")
    
    bounds_left = Bounds.new( 
      canvas[0]*ratio, 
      canvas[1], 
      [left, right + margin/2, 0, 0], 
      leftRangeX, 
      leftRangeY,
      [0,0]) # offset
    
    bounds_right = Bounds.new( 
      canvas[0]*(1-ratio), 
      canvas[1], 
      [left + margin/2, right, 0, 0], 
      rightRangeX, 
      rightRangeY,
      [canvas[0]*ratio,0]) #offset

    return [ bounds_left, bounds_right ]
  end

end