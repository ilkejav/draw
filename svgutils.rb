require "json"
require "date"

class SVG_utils

	def intitialize

	end

  def lerp a, b, t
    return ((1 - t) * a + t * b).round(2)
  end

  def lerp_inverse a, b, x
    return (x - a).to_f / (b - a).round(2)
  end


	def lerp_2d pos1, pos2, progress
		coords = []
		coords[0] = ((1 - progress) * pos1[0] + progress * pos2[0]).round(2)
		coords[1] = ((1 - progress) * pos1[1] + progress * pos2[1]).round(2)
		return coords
	end

	def spread_random pos1, pos2, quantity, randomness
		pts = []
		pts.push( pos1 )
    (1..quantity-1).each do |n|
			coord = lerp_2d( pos1, pos2, n.to_f/quantity )
    	pts.push([
    		(coord.first + rand(-randomness..randomness)).round(2),
    		(coord.last + rand(-randomness..randomness)).round(2)
    	])
    end
		pts.push( pos2 )
    return pts
	end

	def spread_linear pos1, pos2, quantity
    pts = []
    (0..quantity).each do |n|
    	pts.push( lerp_2d( pos1, pos2, n.to_f/quantity ) ).round(2)
    end
    return pts
  end

  def spread_points width, height, offsetX, offsetY, scaleX, scaleY, points
    pts = []
    points.each_with_index do |point,i|
      x = ((i.to_f/(scaleX-1)) * width).to_i + offsetX
      y = height - ((point.to_f/scaleY) * height).to_i + offsetY
      pts.push([x,y])
    end
    return pts
  end

  def find_biggest_value entries
    v = []
    entries.each do |entry|
      max_value = entry.last["data"].max_by { |x| x }
      v.push(max_value)
    end
    return v.max_by { |x| x }
  end

  def find_longest_set entries
    v = []
    entries.each do |entry|
      v.push(entry.last["data"].count)
    end
    return v.max_by { |x| x }
  end

  def round_up number
    divisor = 10 ** Math.log10(number).floor
    i = number / divisor
    remainder = number % divisor
    if remainder == 0
      i * divisor
    else
      (i + 1) * divisor
    end
  end

  def find_position_in_rectangle bounds, progressX, progressY
    coords = []
      coords[0] = lerp(bounds[0], bounds[1], progressX)
      coords[1] = lerp(bounds[3], bounds[2], progressY)
    return coords
  end

  def find_earliest_entry entries
    d = {}
    entries.each do |key,value|
      d[key] = Date.parse(value["start_date"])
    end
    return d.min_by(&:last).first
  end

  def find_latest_entry entries
    d = {}
    entries.each do |key,value|
      d[key] = Date.parse(value["start_date"])
    end
    return d.max_by(&:last).first
  end

  def days_between date1, date2
    return (Date.parse(date2) - Date.parse(date1)).to_i
  end

  def months_between date1, date2
    return (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month)
  end

  def offset_coordinates coords1, coord2
    return [coords1,coord2].transpose.map {|x| x.reduce(:+)}
  end

  # def organize_entries_by_date

  # end

  # def length_of_timeline entries
  #   earliest =
  #   latest = 
  #   return 
  # end
  
end