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

end