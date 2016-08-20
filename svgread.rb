require "nokogiri"

class SVG_read
	
	def initialize 
    
  end

  # def data; return @data end

	def read path, file
    data = Nokogiri::XML(File.open("#{path}/#{file}"))
    
    import = data.css("//path").attr("d").to_s.split("Z")
  	
  	shapes = []
    
    import.each do |x|
				shapes << x.split(/(?=[HVhv])/)
		end
		
		doc = {}
		current_pos = []

		shapes.each_with_index do |shape,shape_index| # iterate through all the shapes

			position = [0,0]
			dimensions = [0,0]
			
			shape.each_with_index do |coord,attr_index| # iterate through all the attributes in the shape
				
				prefix = coord[0]
				data = coord[1..-1].to_i
				
				case prefix
				
				when "M"
					
					c = coord[1..-1].split(",")
					current_pos = [ c.first.to_i, c.last.to_i ]
					if attr_index < 3
						position = [ c.first.to_i, c.last.to_i ] 
					end

				when "m"
					
					c = coord[1..-1].split(",")
					current_pos = [ current_pos[0] + c.first.to_i, current_pos[1] + c.last.to_i ]
					if attr_index < 3
						position = current_pos
					end

				when "H"
					
					current_pos[0] = data
					if attr_index < 3
						dimensions[0] = data
					end

				when "h"
					
					current_pos[0] = current_pos[0] + data
					if attr_index < 3
						dimensions[0] = current_pos[0]
					end

				when "V"
					
					current_pos[1] = data
					if attr_index < 3
						dimensions[1] = data
					end

				when "v"
					
					current_pos[1] = current_pos[1] + data
					if attr_index < 3
						dimensions[1] = current_pos[1]
					end
				# when "Z"
				else
					# puts "what?"
				end

			end

			# puts "#{position} #{dimensions}"
			# puts "#{dimensions}"

			doc["shape#{shape_index}"] = {
				"x" => position.first,
				"y" => position.last,
				"width" => dimensions.first - position.first,
				"height" => dimensions.last - position.last
			}

		end

		return doc

	end

end