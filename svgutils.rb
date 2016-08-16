class SVG_utils

	def intitialize

	end

	def lerp posx1, posy1, posx2, posy2, progress

	end

	def spread_random posx1, posy1, posx2, posy2, points, randomness

	end

	def spread_linear width, height, margin, points
    pts = ""
    points.each_with_index do |point, index|
      pts += "#{margin + (index*(width-margin))/points.count} #{(height-margin)-(point*(height-margin*2))/points.max}, "
    end
    return pts
  end

end