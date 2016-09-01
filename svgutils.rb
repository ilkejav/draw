class SVG_utils

	def intitialize

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

end