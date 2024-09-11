$gtk.reset
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720


class TimeAnimation
  def initialize(args)
    @args = args
  end

  class User
  end

  class Time
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
    def initialize(args, x, y , text)
      @args = args
      @x = x
      @y = y 
      @anchor = 1.5
      @text = text
    end

    def single_line
     return @args.outputs.labels << {x: @x, y: @y, anchor_x: @anchor, anchor_y: @anchor,  text: @text }
    end
    
    def multiple_lines
    end
     
  end

  class Buttons
    def initialize(x, y, size, text )
    end


  end
  
  def current_screen
    render_time
  
  end

  def render_time
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