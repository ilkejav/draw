require_relative "../colors.rb"

class Ggraph

  def initialize
    @colors = Colors.new
    load "Apps/draw/graph/Ggrid.rb"
    load "Apps/draw/DLabel.rb"
    @grid = Ggrid.new
    @label = Dlabel.new
  end

  def colors; return @colors end
  def grid; return @grid end
  def label; return @label end

  def create bounds, subdivX, subdivY, title
    drawing = []

    # draw grid
    drawing.push(
      grid.create(
        bounds.margins,
        subdivX,
        subdivY,
        bounds.rangeX,
        bounds.rangeY
      ))

    # draw title
    drawing.push(
      label.create(
        title, 
        colors.sequence(6,2),
        bounds.lerp_horizontal(0.5),
        bounds.top+12, 
        18, 
        "bottom",
        "plain"
      ))

    # draw legend

    return drawing
  end

end