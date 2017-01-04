require_relative "../svgdraw.rb"
require_relative "../svgutils.rb"
require_relative "../colors.rb"
require "json"
require "date"

class Graph

	def name; return "graph" end

	def initialize
		@draw = SVG_draw.new
		@utils = SVG_utils.new
		@colors = Colors.new
		load "Apps/draw/graph/Gline.rb"
		load "Apps/draw/graph/Gscale.rb"
		load "Apps/draw/graph/Ggrid.rb"
		load "Apps/draw/DLabel.rb"
		@line = Gline.new
		@scale = Gscale.new
		@grid = Ggrid.new
		@label = Dlabel.new
	end

	def draw ; return @draw end
	def utils ; return @utils end
	def colors; return @colors end
	def line; return @line end
	def scale; return @scale end
	def grid; return @grid end
	def label; return @label end

	def create width, height, path, file
		drawing = []

		# TODO make this a utility class
		# bounds = Dbounds.new

		margin = 64
		margins = [32,32,32,32] # left, right, top, bottom
		bounds = [margin, width-margin, height-margin, margin]

		shapes = JSON.load( File.new("#{path}/#{file}", 'r') )

		# find X & Y dimensions of grid
		max_value_all = utils.round_up( 
			utils.find_biggest_value(shapes) )
		longest_set = utils.find_longest_set(shapes)
		
		# draw grid
		drawing.push(
			grid.create(
				width,height,
				margin,
				(longest_set/7).to_i,
				max_value_all/1000,
				longest_set,
				max_value_all
			))

		# show title
		drawing.push(
			draw.draw_text("Castle Story - WEEKLY ACTIVE USERS", colors.sequence(0), width/2, margin+24, 18, "middle")
			)

		# show each shape with its info
		shapes.each_with_index do |shape,i|
			
			s = shape.last

			max_value_local = s["data"].max_by { |x| x }
			max_value_position = s["data"].each_with_index.max[1]
			start_date = Date.parse(s["start_date"]) if s["start_date"]
			start_date_formatted = start_date.strftime('%d %b %Y') if start_date
			
			field_color = colors.sequence(i+4)

			# show field name
			# TODO create label list class
			legend = "#{s["name"]}: #{start_date_formatted}"
			drawing.push(
				label.create(
					legend,
					field_color,
					margin+24,
					(margin+24 + i * 12), 12, "right")
				)

			# show field plot line
			data = s["data"]
			drawing.push( 
				line.create(
					width, 
					height, 
					data, 
					field_color,
					longest_set,
					max_value_all,
					margin)
			)
			
			#show field max value
			max_coords = utils.find_position_in_rectangle(
				bounds,
				max_value_position.to_f/longest_set,
				max_value_local.to_f/max_value_all)
			drawing.push(
				label.create(
					"#{max_value_local}",
					field_color,
					max_coords.first,
					max_coords.last,
					12,
					"top"))

			#show field last value
			last_coords = utils.find_position_in_rectangle(
				bounds,
				(s["data"].length.to_f-1)/(longest_set-1),
				s["data"].last.to_f/max_value_all)
			drawing.push(
				label.create("#{s["data"].last}",field_color, last_coords.first,last_coords.last, 12,"right"))
			drawing.push(
				draw.draw_polyline([[last_coords.first,last_coords.last],[last_coords.first,height-margin]],field_color,0.25,))

			#show field first value
			first_coords = utils.find_position_in_rectangle(
				bounds,
				0,
				s["data"].first.to_f/max_value_all)
			# firstX = utils.lerp(margin, width-margin, 0)
			# firstY = utils.lerp(height-margin, margin, s["data"].first.to_f/max_value_all)
			drawing.push(
				label.create("#{s["data"].first}",field_color, first_coords.first,first_coords.last, 12,"left"))

		end

		drawing.unshift( draw.background(colors.gray_darkest) )
		drawing.unshift( draw.header(width, height) )

		drawing.push( draw.footer )

		return drawing.flatten
	end

end