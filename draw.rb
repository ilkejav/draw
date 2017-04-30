require 'json'

class Draw

	def name; return "draw" end
	
	def run param = nil

		action = param.first.strip.downcase # gets first argument in param
		filepath = param[1].strip.downcase # gets second argument in param 
		
		file = File.basename(filepath) # gets the file name with the extension
		name = File.basename(filepath,".*") # gets the file name without extension
		extension = File.extname(filepath) # gets the extension of the file
		path = File.dirname(filepath) # gets the path of the file without the file

		case action
			
			when "graph"

				load("Apps/draw/graph/graph.rb")
				graph = Graph.new
				content = graph.create(1440, 840, path, file)
				write_to_file(
					path,
					"#{name}_Graph.svg", 
					assemble(content)
					)
				return "done graph!"

			# when "globe"
			 
			#   return "globe!"

			when "normals"
				
				load("Apps/draw/draw_uvs.rb")
				normals = Draw_Uvs.new
				map = normals.create(1024, 1024, path, file)
				write_to_file(
					path,
					"#{name}_Normals.svg", 
					assemble(map)
					)
				return "done normals!"

			when "readsvg"
				
				load("Apps/draw/svgread.rb")
				reader = SVG_read.new
				content = reader.read(path, file)
				write_to_file(
					path,
					"#{name}.json", 
					JSON.pretty_generate(content)
					)
				return "done reading!"

			when "readcsv"	
				
				load("Apps/draw/read_csv.rb")
				reader = Read_CSV.new
				content = reader.convert(path, file)
				# content2 = reader.count(path, file, "Date", ["Net Units Sold","Chargeback/Returns (USD)"])
				write_to_file(
					path,
					"#{name}.json", 
					JSON.pretty_generate(content)
					)
				# write_to_file(
				# 	path,
				# 	"#{name}_condensed.json", 
				# 	JSON.pretty_generate(content2)
				# 	)
				return "done reading!"

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