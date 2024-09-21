class Slide
  attr_accessor 
  def initialize(animated_object, side_bounds, main)
    @animated_object = sliding_object
    @left_bound = side_bounds[0]
    @right_bound = side_bounds[1]
    @main = main
   
    @reverse_direction ||= false
    @bottom_bound = Borders.new(0,(0 - @sliding_object.height), SCREEN_WIDTH, 0, "Vertical")
    @top_bound = Borders.new(0, SCREEN_HEIGHT + @sliding_object.height, SCREEN_WIDTH, 0, "Vertical")
  end

  def animate
    initial_movement
    slide_movement
    side_bounds_reached
    reverse_horizontal_movement
  end

  def initial_movement
    @animated_object.y_pos -= @animated_object.vertical_speed 
  end

  def slide_movement
    vertical_bounds = [@top_bound, @bottom_bound]
    
    vertical_bounds.each do |bounds|
      if @main.collision(bounds, @sliding_object)
        move_vertically(@animated_object)
        move_horizontally(@animated_object)
      end
    end
  end

  def move_horizontally(object)
   object.x_pos += @reverse_direction ?  -object.width : object.width 
  end

  def move_vertically(object)
    object.vertical_speed *= REVERSE_TRAYECTORY
  end

  def side_bounds_reached
    @animated_object.x_pos = [@animated_object.x_pos, @left_bound.x_pos].max
    @animated_object.x_pos = [@animated_object.x_pos, (@right_bound.x_pos - @animated_object.width )].min
  end

  def reverse_horizontal_movement
    bounds = [@left_bound, @right_bound]
   
    bounds.each do |bound|
      if @main.collision(bound, @animated_object)
        @reverse_direction = !@reverse_direction
      end
    end
  end
  
end