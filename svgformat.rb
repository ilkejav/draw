class SVG_format

  def initialize

  end

  def format a , b; return "#{a}=\"#{b}\" " end
  
  def wrap text; return "<#{text}/>" end
  
  def tag text; return "<#{text}>" end

  def build name, arguments
    
    out = "#{name} "
    arguments.each do |arg|
      out += format( arg.first, arg.last.to_s )
    end  
    return out

  end

  def coordinates list
    
    coords = ""
    
    (0..list.length-1).step(2) do |i|
      coords << "#{list[i]} #{list[i+1]}, "
    end
    
    coords = coords.rstrip[0...-1] #"-1" removes the last comma
    return coords
    
  end

end