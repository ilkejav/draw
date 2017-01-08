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
		load "Apps/draw/graph/Gbounds.rb"
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

		timeline = true

		# margin = 64
		margins = [64,64,512,72] # left, right, top, bottom
		bounds = [
			margins[0],
			width-margins[1],
			margins[2],
			height-margins[3]]

		shapes = JSON.load( File.new("#{path}/#{file}", 'r') )

		# find X & Y dimensions of grid
		max_value_all = utils.round_up( 
			utils.find_biggest_value(shapes) )
		longest_set = utils.find_longest_set(shapes)
		earliest_entry = utils.find_earliest_entry(shapes)
		earliest_date = Date.parse(shapes[earliest_entry]["start_date"])
		latest_entry = utils.find_latest_entry(shapes)
		end_of_latest_entry = 
			Date.parse(shapes[latest_entry]["start_date"]).next_day(shapes[latest_entry]["data"].length)
		
		if timeline
			length_of_timeline = 
				utils.days_between(
					earliest_date.to_s,
					end_of_latest_entry.to_s # find a way to remove this unnecessary .to_s 
					)
		else
			length_of_timeline = longest_set
		end
		
		range = Bounds.new(
			[[margins[0],margins[2]],[width-margins[1],height-margins[3]]],
			length_of_timeline,
			max_value_all)

		# draw grid
		drawing.push(
			grid.create(
				bounds,
				(length_of_timeline/utils.months_between(earliest_date,end_of_latest_entry)).to_i,
				max_value_all/1000,
				length_of_timeline,
				max_value_all
			))

		# show title
		drawing.push(
			draw.draw_text("Castle Story - WEEKLY ACTIVE USERS", 
				colors.sequence(6,1), range.lerp_horizontal(0.5), range.top+24, 18, "middle" ))

		# show legend
			# TODO create label list class
		shapes.keys.each_with_index do |key,i|
			s = shapes[key]
			if s["start_date"] 
				then legend = "#{s["name"]}: #{Date.parse(s["start_date"]).strftime('%d %b %Y')}" 
				else legend = "#{s["name"]}" 
			end

			drawing.push(
				label.create(
					legend,
					colors.sequence(i+6,1),
					range.left + 18,
					(range.top + 18 + i * 18),
					12,
					"right",
					"dot")
				)
		end

		# show each shape with its info
		shapes.each_with_index do |shape,i|
			
			s = shape.last

			field_color = colors.sequence(i+6,1)
			
			max_value_local = s["data"].max_by { |x| x }
			max_value_position = s["data"].each_with_index.max[1]
			start_date = Date.parse(s["start_date"])# if s["start_date"]
			start_date_formatted = start_date.strftime('%d %b %Y')# if start_date
			
			if timeline
				offset = range.lerp_horizontal(
					utils.lerp_inverse( earliest_date.to_time.to_i, end_of_latest_entry.to_time.to_i, start_date.to_time.to_i)) - range.left
			else
				offset = 0
			end
			
			# show field plot line
			data = s["data"]

			drawing.push( 
				line.create(range, data, field_color, length_of_timeline, max_value_all,offset)
			)

			# show field max value
			max_coords = utils.offset_coordinates(
				range.lerp_range( max_value_position, max_value_local ), 
				[offset,0])
			
			drawing.push(
				label.create(
					"#{max_value_local}", field_color,
					max_coords.first, max_coords.last,
					12, "top", "dot"))

			# show field last value
			last_coords = utils.offset_coordinates(
				[ range.locate_horizontal_special(s["data"].length-1), range.locate_vertical(s["data"].last) ],
				[offset,0])

			drawing.push(
				draw.draw_polyline([[last_coords.first,last_coords.last],[last_coords.first,bounds[3]]],field_color,0.25,))
			drawing.push(
				label.create("#{s["data"].last}",field_color, last_coords.first,last_coords.last, 10,"right","circle_dot"))

			# show field first value
			if !timeline
				first_coords = range.locate_vertical(s["data"].first)

				drawing.push(
					label.create("#{s["data"].first}",field_color, range.left, first_coords, 10,"left","circle_dot"))
			end

			if s["events"]
				s["events"].each do |key,val|
					event_date = Date.parse(key)
					event_date_formatted = event_date.strftime('%d %b %Y')

					time_from_start = event_date - start_date
					value_at_position = s["data"][time_from_start]
					
					event_name = val
					tag_direction = "top"
					if val.is_a? (Array)
						event_name = val.first
						tag_direction = val.last
					end

					event_pos = utils.offset_coordinates(
						range.lerp_range( time_from_start, value_at_position ),
						[offset,0])

					drawing.push(
						draw.draw_polyline(
							[[event_pos[0],event_pos[1]],[event_pos[0],event_pos[1]-72]], # TODO create lineV and lineH classes
							field_color,
							0.5,))

					drawing.push(
						label.create( event_name, field_color, event_pos[0], event_pos[1]-72, 12, tag_direction, "dot" ))

					drawing.push(
						label.create( "", field_color, event_pos[0], event_pos[1], 12, "bottom", "circle_dot" ))
				end
			end

		end

		drawing.unshift( draw.background(colors.gray_darkest) )
		drawing.unshift( draw.header(width, height) )

		drawing.push( draw.footer )

		return drawing.flatten
	end

end