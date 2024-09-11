$gtk.reset

require "app/all_files.rb"

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
REVERSE_TRAYECTORY = -1 

#Arreglar el clock hitbox en la animación de expand para que se expanda tambiéon, o que en esa animaciuón no aparezca

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
    @clock_expand_animation ||= Expand.new(@clock)

    
    
  end

  class User
  end

  def current_screen
    current_animation
  
  end
  
  def current_animation
    render_clock
    #bounce_animation(@clock_bounce_animation)
    #slide_animation(@clock_slide_animation)
    #expand_animation(@clock_expand_animation)
    color_change_animation
   
    debug
    
  end
  
  def render_clock
    @args.outputs.labels << @clock.current_time
    @args.outputs.borders << @clock.clock_hitbox
  end

 

  def render_options
  end
  
  def bounce_animation(animated_object)
    animated_object.initial_movement
    animated_object.bounce
  end


  def slide_animation(animated_object)
    animated_object.initial_movement
    animated_object.slide_animation
    animated_object.side_bounds_reached
    animated_object.reverse_horizontal_movement
  end

  def expand_animation(animated_object)
    animated_object.expand_and_retract
    animated_object.size_limits
  end

  def color_change_animation
   randomize_color
  
  end

  def randomize_color
    @clock.color.each do |colors|
      puts colors
    end
  end

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
    Text.new(@args, HALF_SCREEN_WIDTH, 600, 15, "#{@clock.color}").single_line
  end

  def tick
    current_screen
  end

end

def tick (args)
 args.state.time_animation ||= TimeAnimation.new(args)
 args.state.time_animation.tick
end