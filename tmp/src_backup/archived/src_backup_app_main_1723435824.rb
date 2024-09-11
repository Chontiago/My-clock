$gtk.reset
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
MAIN_MOVEMENT_SPEED = 3
SECONDARY_MOVEMENT_SPEED = 3

class TimeAnimation
  def initialize(args)
    @args = args
    @time = Time.new

  end

  class User
  end

  class Clock
    attr_accessor :x_pos, :y_pos

    def initialize(args, x, y, w, h, time)
      @x_pos = x
      @y_pos = y
      @size = 20
      @width = 20
      @height = 20 * (@size + 1 ) / 10.0
      @time = time
      @speed = 3
    end

    def current_time
      return  {x: @x_pos, y: @y_pos, size_enum: @size, text: @time}
    end

    
    def clock_borders
      return  {x: @x_pos , y: @y_pos - (@size * 2), w: @width, h: @height} #cambiar a ligarlo con el width del texto 
    end
  end

  class Borders
    def initialize(x_pos, y_pos, w, h)
      attr_accessor :x_pos, :y_pos, :width, :height
      @x_pos = x_pos
      @y_pos = y_pos
      @width = w
      @height= h
      

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
    left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT)
    right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT)
    bottom_border = Borders.new(0,0, SCREEN_WIDTH, 0)
    top_border = Borders.new(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)

    return [left_border, right_border, bottom_border, top_border]
    
  end
  
  def current_screen
    clock
    render_clock
    #bounce_animation
  end

  def clock
    
    @clock ||= Clock.new(@args, HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, 50, 50, "#{@time.hour} : #{@time.min}")
  end

  def render_clock
    @args.outputs.labels << @clock.current_time
    @args.outputs.solids << @clock.clock_borders
  end

  def current_animation(user_settings)
  end

  def render_options
  end
  
  def bounce_animation
    bounce_animation_initial_movement
  end

  def bounce_animation_initial_movement
    @clock.x_pos += MAIN_MOVEMENT_SPEED
    @clock.y_pos += MAIN_MOVEMENT_SPEED
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