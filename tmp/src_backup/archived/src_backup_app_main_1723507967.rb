$gtk.reset
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2




class TimeAnimation
  def initialize(args)
    @args = args
    @time = Time.new

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

  class Animations
    def initialize(animated_object, animation, *borders)
      @x = animated_object.x_pos
      @y = animated_object.y_pos
      borders.each do |border|
        @border = border
      end
    end

    def bounce
      
      
    end

    def expand
    end

    def scroll
    
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
    bottom_border = Borders.new(0,0, SCREEN_WIDTH, 0, "Vertical" )
    top_border = Borders.new(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0, "Vertical")

    return [left_border, right_border, bottom_border, top_border]
    
  end
  
  def current_screen
    clock
    render_clock
    bounce_animation
  end

  def clock
    
    @clock ||= Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@time.hour} : #{@time.min}")
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
    bounce_animation_initial_movement
    bounce
  end

  def bounce_movement(border, object)
    reverse_trayectory = -1.01


    if border.bounce_angle == "Vertical"
      object.vertical_speed *= reverse_trayectory
    else
      object.horizontal_speed *= reverse_trayectory
      
    
    end

  end

  def random_trayectory 
    randomize_trayectory = [1, -1]
    random_trayectory = randomize_trayectory.sample
    return random_trayectory
  end 
    

  def bounce
    screen_borders.each do |border|
      if collision(@clock, border)
        puts "ahhhhhh"
      end
    
    end
  end

  def bounce_animation_initial_movement
    @clock.x_pos += @clock.horizontal_speed
    @clock.y_pos += @clock.vertical_speed
  end
  
  def collision(box1, box2) #box1 ball, box2 object
    box1.y_pos <= box2.y_pos + box2.height &&  
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