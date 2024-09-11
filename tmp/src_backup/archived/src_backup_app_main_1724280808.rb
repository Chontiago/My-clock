$gtk.reset
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
REVERSE_TRAYECTORY = -1

#Arreglar los borders para que no sean estáticos
#Hacer las funciones más geéricas para que no acepten solo clock en el código_principal

require "app/bounce.rb", "app/clock.rb"


class TimeAnimation
  def initialize(args)
    @args = args
    @time = Time.new
    @clock = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@time.hour}:#{@time.min}")
    
    @bottom_border = Borders.new(0, 50, SCREEN_WIDTH, 10, "Vertical")
    @top_border = Borders.new(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0, "Vertical")
    @left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT, "Horizontal")
    @right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT, "Horizontal")

    
    @clock_bounce_animation ||= Bounce.new(@clock, [@left_border, @right_border, @top_border, @bottom_border], self) 
    @clock_slide_animation ||= Slide.new(@clock, [@left_border, @right_border], self)
    
  end

  class User
  end



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

  
  
  class Slide
    def initialize(sliding_object, side_bounds, main)
      @sliding_object = sliding_object
      @left_bound = side_bounds[0]
      @right_bound = side_bounds[1]
      @main = main
     
      @reverse_direction ||= false
      @bottom_bound = Borders.new(0,(0 - @sliding_object.height), SCREEN_WIDTH, 0, "Vertical")
      @top_bound = Borders.new(0, SCREEN_HEIGHT + @sliding_object.height, SCREEN_WIDTH, 0, "Vertical")
 

    end

    def initial_movement
      @sliding_object.y_pos -= @sliding_object.vertical_speed 
    end

    

    def slide_animation
      vertical_bounds = [@top_bound, @bottom_bound]
      
      vertical_bounds.each do |bounds|
        if @main.collision(bounds, @sliding_object)
          move_vertically(@sliding_object)
          move_horizontally(@sliding_object)
        end
      end
    end

    def move_horizontally(object)
     object.x_pos += @reverse_direction ?  -object.width : object.width 
      
    end

    def move_vertically(object)
      object.vertical_speed *= REVERSE_TRAYECTORY
    end

    def side_bounds
      bounds_reached

      @sliding_object.x_pos = [@sliding_object.x_pos, @left_bound.x_pos].max
      @sliding_object.x_pos = [@sliding_object.x_pos, (@right_bound.x_pos - @sliding_object.width )].min
    end

    def bounds_reached
      bounds = [@left_bound, @right_bound]
     
      bounds.each do |bound|
        if @main.collision(bound, @sliding_object)
          @reverse_direction = !@reverse_direction
        end
      end
    end
    
  end

  class Text 
    attr_accessor :x_pos, :y_pos
    def initialize(args, x, y, size, text ,skip_space=50)
      @args = args
      @x_pos = x
      @y_pos = y 
      @size = size
      @anchor = 1.5
      @text = text
      @skip_space = skip_space
    end

    def single_line
      @args.outputs.labels << {x: @x_pos, y: @y_pos, size_enum: @size, text: @text }
    end
    
    def multiple_lines
      @text.each_with_index do |text, index|
        @args.outputs.labels << {x: @x_pos, y:@y_pos + (index * @skip_space) , anchor_x: @anchor, anchor_y: @anchor, text: text}
      end
    end
     
  end

  class Buttons
    def initialize(args, x, y, width, height, text )
    end
  end

  def screen_borders
    @left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT, "Horizontal")
    @right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT, "Horizontal")
    @bottom_border = Borders.new(0, 50, SCREEN_WIDTH, 10, "Vertical")
    @top_border = Borders.new(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0, "Vertical")

    

    return [@left_border, @right_border, @top_border, @bottom_border]
    
  end
  
  def current_screen
    render_clock
    bounce_animation
    #slide_animation
    
    
  end
  
  def render_clock
    @args.outputs.labels << @clock.current_time
    @args.outputs.borders << @clock.clock_hitbox
  end

  def current_animation(user_settings)
  
  end

  def render_options
  end
  
  def bounce_animation
    @clock_bounce_animation.initial_movement
    @clock_bounce_animation.bounce
  end


  def slide_animation
    
    @clock_slide_animation.initial_movement
    @clock_slide_animation.side_bounds
    @clock_slide_animation.slide_animation
  
  end

  
  def collision(box1, box2) #box1 border, box 2 clock
    box1.y_pos <= box2.y_pos &&  
    box1.y_pos + box1.height >= box2.y_pos  &&
    box1.x_pos <= box2.x_pos + box2.width &&
    box1.x_pos + box1.width >= box2.x_pos 
  end

  def tick
    current_screen
  end

end

def tick (args)
 args.state.time_animation ||= TimeAnimation.new(args)
 args.state.time_animation.tick
end