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
		load "Apps/draw/graph/Ggrid.rb"
		load "Apps/draw/graph/Gbounds.rb"
		load "Apps/draw/graph/Ggraph.rb"
		load "Apps/draw/graph/Gquery.rb"
		load "Apps/draw/DLabel.rb"
		@line = Gline.new
		@grid = Ggrid.new
		@label = Dlabel.new
	end

	def draw ; return @draw end
	def utils ; return @utils end
	def colors; return @colors end
	def line; return @line end
	def grid; return @grid end
	def label; return @label end

	def create width, height, path, file
		drawing = []

		timeline = false

		shapes = JSON.load( File.new("#{path}/#{file}", 'r') )

		# =======================
		# find all relevant data
		# =======================

		query = Gquery.new(shapes)
		max_value_all = query.max_value_all()
		earliest_date = query.earliest_date()
		latest_entry = query.latest_entry()
		end_of_latest_entry = query.end_of_latest_entry()
		
		if timeline
			length_of_timeline = query.length_of_timeline()
		else
			length_of_timeline = query.find_longest_set()
		end

		# ========================
		# Create new graph object
		# ========================

		range = Bounds.new(
			width, height,
			[128,128,128,128], # margins left, right, top, bottom
			length_of_timeline, # rangeX
			query.max_value_all(), # rangeY,
			[0,0])

		canvas_left_right = 
			range.divide_vertical(0.6,128,range.rangeX,range.rangeY,range.rangeX,range.rangeY)
			p(canvas_left_right[0])
			p(canvas_left_right[1])
		
		# draw graph grid & title
		drawing.push(
			Ggraph.new().create(
				range,
				query.length_of_timeline_months,
				query.find_best_power_of_10,
				"#{file}".split(".").first
			))

		# drawing.push(
		# 	Ggraph.new().create(
		# 		canvas_left_right.last,
		# 		query.length_of_timeline_months,
		# 		query.find_best_power_of_10,
		# 		"#{file}".split(".").first
		# 	))

		# show legend
			# TODO create label list class
		shapes.keys.each_with_index do |key,i|
			s = shapes[key]
			if s["start_date"] 
				then legend = "#{s["name"]}: #{Date.parse(s["start_date"]).strftime('%d %b %Y')}" 
				else legend = "#{s["name"]}" 
			end

			if i == shapes.length - 1
					label_color = colors.sequence(i+1,2)
			else
					label_color = colors.sequence(i+1,1)
			end

			drawing.push(
				label.create(
					legend,
					label_color,
					range.left + 18,
					(range.top + 18 + i * 18),
					12,
					"right",
					"dot")
				)
		end

		# ==============================
		# draw each shape with its info
		# ==============================
		shapes.each_with_index do |shape,i|
			
			s = shape.last

			if i == shapes.length - 1
					field_color = colors.sequence(i+1,2)
			else
					field_color = colors.sequence(i+1,1)
			end
			
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
				line.create(range, data, field_color, length_of_timeline, max_value_all,offset,"filled")
			)

			# show field max value
			max_coords = utils.offset_coordinates(
				range.lerp_range( max_value_position, max_value_local ), 
				[offset,0])
			
			drawing.push(
				label.create(
					"#{max_value_local}", field_color,
					max_coords.first, max_coords.last,
					10, "top", "dot"))

			# show field last value
			last_coords = utils.offset_coordinates(
				[ range.locate_horizontal_special(s["data"].length-1), range.locate_vertical(s["data"].last) ],
				[offset,0])

			drawing.push(
				draw.draw_polyline([[last_coords.first,last_coords.last],[last_coords.first,range.bottom]],field_color,0.25,))
			drawing.push(
				label.create("#{s["data"].last}",field_color, last_coords.first,last_coords.last, 10,"right","circle_dot"))

			# show field first value
			if !timeline
				first_coords = range.locate_vertical(s["data"].first)

				drawing.push(
					label.create("#{s["data"].first}",field_color, range.left, first_coords, 10,"left","circle_dot"))
			end

			# ============================================
			# for each shape, find & draw releated events
			# ============================================

			if s["events"]
				s["events"].each do |key,val|
					event_date = Date.parse(key)
					event_date_formatted = event_date.strftime('%d %b %Y')

					time_from_start = event_date - start_date
					value_at_position = s["data"][time_from_start]
					
					biggest_value_after = range.locate_vertical(
						s["data"][time_from_start..time_from_start+10].max_by { |x| x } - value_at_position
						)
					smallest_value_after = range.locate_vertical(
						s["data"][time_from_start..time_from_start+10].min_by { |x| x } - value_at_position
						)
					# puts("#{biggest_value_after}  #{smallest_value_after}")

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
							[[event_pos[0],event_pos[1]],[event_pos[0],biggest_value_after-24]], # TODO create lineV and lineH classes
							field_color,
							0.5,))

					drawing.push(
						label.create( event_name, field_color, event_pos[0], biggest_value_after-24, 12, tag_direction, "dot" ))

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