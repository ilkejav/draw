class Normal_map

	def initialize
		
	end

	def box posx, posy, width, height, bevel, bleed

		load "Apps/draw/normals/Nbox.rb"
		drawing = Nbox.new
		return drawing.create(
			posx, posy, width, height, bevel, bleed
			)

	end

	def brick posx, posy, width, height, bevel, bleed, chamfer, randomness

		load "Apps/draw/normals/Nbrick.rb"
		drawing = Nbrick.new
		brick = drawing.create(
			posx, posy, width, height, bevel, bleed, chamfer, randomness
			) 
		return brick 

	end

	def indent posx, posy, width, height, bevel, bleed, bevel2, bleed2, direction

		load "Apps/draw/normals/Nindent.rb"
		drawing = Nindent.new
		return drawing.create(
			posx, posy, width, height, bevel, bleed, bevel2, bleed2, direction
			)
	
	end

	def corner posx, posy, width, height, bevel, bleed, sides

		load "Apps/draw/normals/Ncorner.rb"
		drawing = Ncorner.new
		return drawing.create(
			posx, posy, width, height, bevel, bleed, sides
			)
	
	end

	def plank posx, posy, width, height, direction, bevel, bleed, randomness

		load "Apps/draw/normals/Nplank.rb"
		drawing = Nplank.new
		return drawing.create(
			posx, posy, width, height, direction, bevel, bleed, randomness
			)

	end

	# def crack posx, posy, length, width, direction, randomness

	# end

end