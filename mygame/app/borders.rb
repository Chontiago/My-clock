class Borders
  attr_reader :x_pos, :y_pos, :width, :height, :bounce_angle
  def initialize(x_pos, y_pos, w, h, bounce_angle)
    
    @x_pos = x_pos
    @y_pos = y_pos
    @width = w
    @height= h
    @bounce_angle = bounce_angle #string either "Vertical or Horizontal"
    

    def set_borders
      return {x: @x_position, y: @y_position, w: @width, h: @height}
    end

  end
  
end