require_relative("svgdraw.rb")
require_relative("colors.rb")

class Draw

  def name; return "draw" end

  def initialize

    @draw = SVG_draw.new
    @colors = Colors.new

  end

  def draw; return @draw end
  def colors; return @colors end

  def width; return 1280 end
  def height; return 720 end
  def margin; return 32 end
  
  def run param = nil

    data1 = [4,3,5,7,4,2,4,6,8,8,3,1,3,6,7,3,4,2,1]
    data2 = [2,3,7,7,3,2,3,1,7,3,8,5,3,1,2,5,6,8,2]

    drawing = [
      draw.header(width, height),
      draw.background(width, height, colors.gray_dark),
      draw.draw_polyline(data1, width, height, margin, colors.magenta),
      draw.draw_polyline(data2, width, height, margin, colors.blue_light),
      draw.draw_scale(width, height, margin, colors.gray_lightest),
      draw.draw_text("Grabelshpouet", colors.magenta,"50%", height-margin/2, colors.gray_dark),
      draw.footer
    ]

    write_to_file("Apps/draw/","test.svg", assemble(drawing))
    
    return "done!"

  end

  def assemble lines
    
    text = ""
    lines.each do |line|
      text += "#{line}\n"
    end
    return text
  
  end

  def write_to_file path, file_name, data

    File.open("#{path}#{file_name}", "w") do |file|
      file.write(data)    
    end

  end

end


      