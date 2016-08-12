require_relative "globe.rb"
require_relative "earth.rb"

size = 800
header = '<?xml version="1.0" encoding="UTF-8"?><svg viewBox="0 0 800 800" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">'
footer = '</svg>'
@radius = 11
globe = Globe.new
earth = Earth.new
background = '<rect width="100%" height="100%" fill="#eee" />'

#Draws SVG circle object
def svg_circle coordinate, circle_radius, color
  return '<circle cx="' + "#{coordinate[0] + 400}" + '" cy="' + "#{coordinate[1] + 400}" + '" r="' + "#{circle_radius}" + '" style="fill:' + color + ';"/>'
end

#Draws SVG polygon node
def poly_node coordinate
  return "#{coordinate[0].round(3) + 400},#{coordinate[1].round(3) + 400} "
end

content = ""

# DRAW GRID
# (0..72).each do |x|
#   (0..36).each do |y|

#     lat_lon = [5 * x, 5 * y]

#     pos = globe.sphere_plot(lat_lon, @radius)

#     content += "#{svg_circle(pos, 1, '#aaa')}\n"

#   end
# end

outlines = earth.draw_countries

outlines.each_with_index do |country,index|

  next unless index == 34

  country_is_visible = false
  country_coordinates = []

  country.each do |coordinate|
    lat_lon = [coordinate.first, coordinate.last]

    pos = globe.sphere_plot(lat_lon, @radius)
    
    if globe.occlude lat_lon
      country_coordinates << [lat_lon, @radius]
      country_is_visible = true
    else
      country_coordinates << [lat_lon, @radius]
    end
    # content += "#{svg_circle(pos, 1, '#444')}\n" if globe.occlude lat_lon
  end

  if country_is_visible
    content << '<polygon points="'
    country_coordinates.each do |coord|
      content << poly_node( globe.sphere_plot( coord[0], coord[1] ))
    end
    content << '" style="fill:#ff3092;stroke: #fff;stroke-width:0.3" />'
    content << "\n"
  end

end

data = "#{header}\n#{background}\n#{content}\n#{footer}"

File.open("globe.svg", 'w') do |file|
  file.write(data)    
end