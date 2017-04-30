require "date"

class Gquery

	def initialize data
    load "Apps/draw/svgutils.rb"
    @utils = SVG_utils.new
    @data = data

	end

  def utils ; return @utils end 
  def data ; return @data end 

  def max_value_all
    return utils.round_up( utils.find_biggest_value(data) )
  end

  def find_best_power_of_10 # TODO make this better
    return (max_value_all/1000).to_i
  end

  def find_longest_set
    return utils.find_longest_set(data)
  end

  def earliest_entry
    return utils.find_earliest_entry(data)
  end

  def earliest_date
    return Date.parse(data[earliest_entry]["start_date"])
  end

  def latest_entry
    return utils.find_latest_entry(data)
  end

  def end_of_latest_entry
    return Date.parse(data[latest_entry]["start_date"]).next_day(data[latest_entry]["data"].length)
  end

  def length_of_timeline
    return utils.days_between(
      earliest_date.to_s, end_of_latest_entry.to_s)
  end

  def length_of_timeline_months
    return (length_of_timeline/utils.months_between(earliest_date,end_of_latest_entry)).to_i
  end

end