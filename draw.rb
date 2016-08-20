require_relative "svgdraw.rb"
require_relative "draw_uvs.rb"
require_relative "colors.rb"
require 'json'

class Draw

  def name; return "draw" end

  def initialize

    @draw = SVG_draw.new
    @colors = Colors.new

  end

  def draw; return @draw end
  def colors; return @colors end
  
  def run param = nil

    action = param.first.strip.downcase # gets first argument in param
    filepath = param[1].strip.downcase # gets second argument in param 
    
    file = File.basename(filepath) # gets the file name with the extension
    name = File.basename(filepath,".*") # gets the file name without extension
    extension = File.extname(filepath) # gets the extension of the file
    path = File.dirname(filepath) # gets the path of the file without the file

    case action
    
    # when "graph"
      
    #   width = 1280
    #   height = 720
    #   margin = 32
      
    #   drawing = [
    #     draw.header(width, height),
    #     draw.background(width, height, colors.gray_dark),
    #     draw.draw_polyline(data1, width, height, margin, colors.magenta),
    #     draw.draw_polyline(data2, width, height, margin, colors.blue_light),
    #     draw.draw_scale(width, height, margin, colors.gray_lightest),
    #     draw.draw_text("Grabelshpouet", colors.magenta,"50%", height-margin/2, colors.gray_dark),
    #     draw.footer
    #   ]
    #   write_to_file("Apps/draw/","test.svg", assemble(drawing))

    #   return "done!"

    # when "globe"
     
    #   return "globe!"

    when "normals"
      
      load("Apps/draw/normal_map.rb")
      normals = Draw_Uvs.new
      map = normals.create(1024, 1024, path, file)
      write_to_file(
        path,"#{name}_Normals.svg", 
        assemble(map)
        )
      return "done normals!"

    when "read"
      
      load("Apps/draw/svgread.rb")
      reader = SVG_read.new
      content = reader.read(path, file)
      write_to_file(
        path,"#{name}.json", 
        JSON.pretty_generate(content)
        )
      return "done reading!"

    # when "uvs"
      
    #   uv_mapper = Draw_Uvs.new
    #   uvs = uv_mapper.create(1024,1024)
    #   write_to_file("Apps/draw/","uvs.svg", assemble(uvs))
    #   return "done uvs!"

    else
      
      return "please specify something to draw"

    end

  end


  def assemble lines
    
    text = ""
    lines.each do |line|
      text += "#{line}\n"
    end
    return text
  
  end


  def write_to_file path, file_name, data
    File.open("#{path}/#{file_name}", "w") do |file|
      file.write(data)    
    end

  end

end