require "nokogiri"

class Earth
  def initialize
    # @data = File.open("earth.svg") { |f| Nokogiri::XML(f) }
    @data = Nokogiri::XML(File.open("earth.svg"))
  end

  def data; return @data end

  def draw_countries
    
    root = data.root
    import = data.css("//path")

    countries = []

    import.each do |x| # for each entry in the dataset 
      path = x.to_s.split('"')[1] # select the text between the double quotes
      islands = path.split("Z")
      coords.delete_if {|a| a =~ /[A-Za-z]/ }
      
      outline = []
      coords.each do |coordinate|

        x = coordinate.split(",").first.to_f
        y = coordinate.split(",").last.to_f - 90 # we map the longitude from -90 to 90
        pair = [x,y]
        outline << pair
      end

      countries << outline
    end

    return countries



    # puts group_count

  end

end