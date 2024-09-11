$gtk.reset

require "app/all_files.rb"

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
REVERSE_TRAYECTORY = -1

#Arreglar los borders para que no sean estáticos
#Hacer las funciones más geéricas para que no acepten solo clock en el código_principal

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
    @clock_slide_animation.initial_movement
    @clock_slide_animation.slide_animation
    @clock_slide_animation.side_bounds
    @clock_slide_animation.reverse_movement_if_side_bounds_reached
  
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