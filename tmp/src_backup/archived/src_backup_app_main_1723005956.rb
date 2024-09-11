$gtk.reset
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2


class TimeAnimation
  def initialize(args)
    @args = args
    @test ||= Text.new(@args, HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "HOLA" )
  end

  class User
  end

  class Animations
    def initialize
    end

    def bounce
    end

    def expand
    end

    def scroll
    
    end
  end

  class Text 
    def initialize(args, x, y , text ,skip_space=50)
      @args = args
      @x = x
      @y = y 
      @anchor = 1.5
      @text = text
      @skip_space
    end

    def single_line
      @args.outputs.labels << {x: @x, y: @y, anchor_x: @anchor, anchor_y: @anchor,  text: @text }
    end
    
    def multiple_lines
      @text.each do |text|
        @args.outputs.labels << {x: @x, y:@y, anchor_x: @anchor, anchor_y: @anchor, text: text}
      end
    end
     
  end

  class Buttons
    def initialize(args, x, y, width, height, text )
    end
  end
  
  def current_screen
    render_time
  end

  def render_time
    time = Time.new
    current_time = [time.hour, time.min]
    @time_screen ||= Text.new(@args, HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, current_time)


  end

  def render_options
  end


  def tick
    current_screen
  end
  
 
end

def tick (args)
 args.state.time_animation ||= TimeAnimation.new(args)
 args.state.time_animation.tick
end