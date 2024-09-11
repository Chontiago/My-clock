$gtk.reset
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
REVERSE_TRAYECTORY = -1




class TimeAnimation
  def initialize(args)
    @args = args
    @time = Time.new
    @clock = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@time.hour}:#{@time.min}")
    
    @clock_bounce_animation ||= Bounce.new(@clock, screen_borders) 
    
  end

  class User
  end

  class Clock
    attr_accessor :x_pos, :y_pos, :horizontal_speed, :vertical_speed, :width, :height

    def initialize(x, y, time)
      @x_pos = x
      @y_pos = y
      @time = time
      @size = 20
      @width = (@time.length * 10) + (@time.length * @size) # Can still be improved to scale better
      @height = 20 + (@size * 2)
      @vertical_speed = 3
      @horizontal_speed = 3
    end

    def current_time
      return  {x: @x_pos, y: @y_pos, size_enum: @size, text: @time}
    end

    
    def clock_hitbox # used for animations such as bounce
      return  {x: @x_pos , y: @y_pos - @height , w: @width, h: @height} #cambiar a ligarlo con el width del texto 
    end
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

  class Bounce
    def initialize(bouncing_object, borders)
      @bouncing_object = bouncing_object
      @borders = borders
      
    end

    def initial_movement
      @bouncing_object.x_pos += @bouncing_object.horizontal_speed
      @bouncing_object.y_pos += @bouncing_object.vertical_speed 
    end

    def bounce_trayectory(border, object)
      

      if border.bounce_angle == "Vertical"
        object.vertical_speed *= REVERSE_TRAYECTORY
      else
        object.horizontal_speed *= REVERSE_TRAYECTORY
          
      end
    end

    def bounce
      @borders.each do |border|
        if collision(border, @bouncing_object)
          bounce_trayectory(border, @bouncing_object)
        end
      end
    end

    def collision(box1, box2) #box1 border, box 2 clock
      box1.y_pos <= box2.y_pos &&  
      box1.y_pos + box1.height >= box2.y_pos  &&
      box1.x_pos <= box2.x_pos + box2.width &&
      box1.x_pos + box1.width >= box2.x_pos 
    end
  end
  
  class Slide
    def initialize
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
    left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT, "Horizontal")
    right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT, "Horizontal")
    bottom_border = Borders.new(0, 50, SCREEN_WIDTH, 10, "Vertical")
    
    top_border = Borders.new(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0, "Vertical")

    

    return [left_border, right_border, top_border, bottom_border]
    
  end

  def outside_of_screen_borders
    #left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT, "Horizontal")
    #right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT, "Horizontal")
    bottom_border = Borders.new(0,(0 - @clock.height), SCREEN_WIDTH, 0, "Vertical")
    top_border = Borders.new(0, SCREEN_HEIGHT + @clock.height, SCREEN_WIDTH, 0, "Vertical")

    return [top_border, bottom_border]
  end
  
  def current_screen
    render_clock
    #bounce_animation
    slide_animation
    
    
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
    
    initial_movement(@clock)
    screen_limits
    side_animation
    
  end

  def initial_movement(object)
    object.y_pos -= object.vertical_speed
  end

  def screen_limits
   @reverse ||= false

    outside_of_screen_borders.each do |border|
      if collision(border, @clock)
        @clock.vertical_speed *= REVERSE_TRAYECTORY
          if @reverse == false
            @clock.x_pos = @clock.x_pos + @clock.width
          else
            @clock.x_pos = @clock.x_pos - @clock.width
        end

      end
    end
  end

  def side_animation
    left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT, "Horizontal")
    right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT, "Horizontal") 

    borders = [left_border, right_border]

    borders.each do |border|
      if collision(border, @clock)
        if @reverse == false
          @reverse = true
        else
          @reverse = false
        
        end
      end
    end



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