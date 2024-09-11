$gtk.reset

require "app/all_files.rb"

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
REVERSE_TRAYECTORY = -1 

#Arreglar el clock hitbox en la animación de expand para que se expanda tambiéon, o que en esa animaciuón no aparezca
#Cambiar las animaciones a que sean genericas y acepten cualquier objeto y no solo @clock


class TimeAnimation
  def initialize(args)
    @args = args
    @time = Time.new
    #@clock = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@time.hour}:#{@time.min}")
    
    
    @clock_hour = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@time.hour}")
    @clock_colon = Clock.new(HALF_SCREEN_WIDTH + @clock_hour.width, HALF_SCREEN_HEIGHT, ":")
    @clock_minutes = Clock.new(HALF_SCREEN_WIDTH + @clock_hour.width + @clock_colon.width, HALF_SCREEN_HEIGHT, "#{@time.min}")

    @clock = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@clock_hour}")

    @full_clock = [@clock_hour, @clock_colon, @clock_minutes]
    
    
    @bottom_border = Borders.new(0, 50, SCREEN_WIDTH, 10, "Vertical")
    @top_border = Borders.new(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0, "Vertical")
    @left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT, "Horizontal")
    @right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT, "Horizontal")

    @clock_bounce ||= Bounce.new(@clock, [@left_border, @right_border, @top_border, @bottom_border], self) 
    @clock_slide ||= Slide.new(@clock, [@left_border, @right_border], self)
    @clock_expand ||= Expand.new(@clock)
    @clock_color_change ||= ColorChange.new(@args, @full_clock) #Takes an array to animate each element individually
    
  end
  
  def clock_objects
  
  end
  
  def clock_animations #Creates an animation for clock, using the Classes for each animation
    
    
  end

 def options
    options = {"Bounce" => @clock_bounce, "Slide" => @clock_slide, "Expand" => @clock_expand, "Color Change" => @clock_color_change}
 end

  

  def current_screen
    render_clock
    current_animation(@clock_expand)
  
  end
  
  def render_clock
    @args.outputs.labels << @clock.current_time
    
    #@full_clock.each do |clock|
     # @args.outputs.labels << clock.current_time
    #end

    @args.outputs.borders << @clock.clock_hitbox
  end

 

  def render_options
  end

  def current_animation(animated_object)
    animated_object.animate
  end

  #Helper functions
  def key_pressed(key_action, key, output)
    if @args.inputs.keyboard.send(key_action).send(key)
      call(output)
    end
  end
  
  def collision(box1, box2) #box1 border, box 2 clock
    box1.y_pos <= box2.y_pos &&  
    box1.y_pos + box1.height >= box2.y_pos  &&
    box1.x_pos <= box2.x_pos + box2.width &&
    box1.x_pos + box1.width >= box2.x_pos 
  end

  def debug 
    debug_text =  ["#{@counter}", "#{@current_element}", "#{@invert}" ]
    Text.new(@args, HALF_SCREEN_WIDTH, 600, 10,  debug_text,).multiple_lines
  end

  def tick
    current_screen
  end

end

def tick (args)
 args.state.time_animation ||= TimeAnimation.new(args)
 args.state.time_animation.tick
end