class Colors

	def initialize

	end

	def gray_lightest; return "#595959" end 
	def gray_light; return "#E6E6E6" end 
	def gray; return "#595959" end 
	def gray_dark; return "#383830" end
	def gray_darker; return "#272822" end 
	def gray_darkest; return "#141411" end
	def blue; return "#2196F3" end
	def blue_light; return "#89BDFF" end 
	def green; return "#A6E22A" end 
	def green_light; return "#A6E22E" end 
	def magenta; return "#F92672" end 
	def purple; return "#AE81FF" end 
	def purple_light; return "#FD5FF1" end 
	def yellow; return "#E6DB74" end 
	def yellow_dark; return "#75715E" end
	def yellow_light; return "#F8F8F2" end 

	def normal; return "#8080ff" end
	def up; return "#80dbda" end
	def down; return "#8026da" end
	def left; return "#2580da" end
	def right; return "#da80da" end
	
	def up_right; return "#cacaca" end
	def up_left; return "#36caca" end
	def down_left; return "#3636ca" end
	def down_right; return "#ca36ca" end

	# def normals x, y
		
	#   return "##{}"
	# end

	def sequence index
		colors = [
		"#673AB7",		# DeepPurple : #673AB7
		"#3F51B5",		# Indigo : #3F51B5
		"#2196F3",		# Blue: #2196F3
		# "#03A9F4", 		# LightBlue : #03A9F4
		"#00BCD4",		# Cyan : #00BCD4
		# "#009688", 		# Teal : #009688
		"#4CAF50",		# Green : #4CAF50
		"#8BC34A", 			# LightGreen : #8BC34A
		"#CDDC39",		# Lime : #CDDC39
		# "#FFEB3B",		# Yellow : #FFEB3B
		"#FFC107",		# Amber : #FFC107
		"#FF9800",		# Orange : #FF9800
		"#FF5722",		# DeepOrange : #FF5722
		"#F44336",		# Red : #F44336
		"#E91E63",		# Pink : #E91E63
		"#9C27B0",		# Purple : #9C27B0
		# "#795548",		# Brown : #795548
		# "#9E9E9E",		# Grey : #9E9E9E
		# "#607D8B" 		# BlueGrey : #607D8B
		]
		return colors[index % 13]
	end

end