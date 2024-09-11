class Clock
  attr_accessor :x_pos, :y_pos, :horizontal_speed, :vertical_speed, :width, :height, :size, .:red, :green, :blue

  def initialize(x, y, time)
    @x_pos = x
    @y_pos = y
    @time = time
    @size = 20
    @width = (@time.length * 10) + (@time.length * @size) # Can still be improved to scale better
    @height = 20 + (@size * 2)
    @vertical_speed = 3
    @horizontal_speed = 3
    @color = [0, 0, 0]
    @red = 0
    @green = 0
    @blue = 0
  end

  def current_time
    return  {x: @x_pos, y: @y_pos, size_enum: @size, text: @time, r: @red, g: @green, b: @blue}
  end

  
  def clock_hitbox # used for animations such as bounce
    return  {x: @x_pos , y: @y_pos - @height , w: @width, h: @height} #cambiar a ligarlo con el width del texto 
  end
end