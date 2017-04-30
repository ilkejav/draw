require "csv"
require "json"
require "date"

class Read_CSV

  def initialize

  end

  # def read path, file
  #   file = CSV.read(File.new("#{path}/#{file}", 'r'))

  #   p(file[1]) # prints the date range
  #   p(file[3]) # prints the column names

  # end

  def convert path, file

    data = {}
    modifiers = []
    data["net sales"] = {"name" => "Net Sales", "data" => []}
    data["returns"] = {"name" => "Returns", "data" => []}
    data["net revenue"] = {"name" => "Net Revenue", "data" => []}

    CSV.foreach("#{path}/#{file}").with_index(0) do |row, index|


      if index == 0 # row 0 is the lablels row
        modifiers = row
      elsif index == 1 # row 1 should be the first entry
        data["net sales"]["start_date"] = row.first
        data["returns"]["start_date"] = row.first
        # data["net revenue"]["start_date"] = row.first
      else # this should be the rest of the entries
        data["net sales"]["data"].push(row[1].to_i)
        data["returns"]["data"].push(row[2].to_i)
        # data["net revenue"]["data"].push(row[4].to_f)
      end

    end

    return data

  end

  # def count path, file, key = "Date", points = []

  #   data = {}

  #   content = convert(path,file)
    
  #   content.each do |i| # iterate through entries

  #     date = i["Date"]
  #     units = i["Net Units Sold"].to_i
  #     refunds = i["Chargeback/Returns (USD)"].to_i

  #     if data.has_key?(date)
  #       data[date]["units"] += units
  #       data[date]["refunds"] += refunds
  #     else
  #       data[date] = {}
  #       data[date]["units"] = units
  #       data[date]["refunds"] = refunds
  #     end
      
    
  #   end

  #   puts(data)

  #   return data
  # end
end
