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
    
    @clock_hour = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT + 50, "#{@time.hour}")
    @clock_colon = Clock.new(HALF_SCREEN_WIDTH + @clock_hour.width, HALF_SCREEN_HEIGHT + 50, ":")
    @clock_minutes = Clock.new(HALF_SCREEN_WIDTH + @clock_hour.width + @clock_colon.width, HALF_SCREEN_HEIGHT + 50, "#{@time.min}")

    @full_clock = [@clock_hour, @clock_colon, @clock_minutes]
    
    
    @bottom_border = Borders.new(0, 50, SCREEN_WIDTH, 10, "Vertical")
    @top_border = Borders.new(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0, "Vertical")
    @left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT, "Horizontal")
    @right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT, "Horizontal")

    @clock_bounce_animation ||= Bounce.new(@clock, [@left_border, @right_border, @top_border, @bottom_border], self) 
    @clock_slide_animation ||= Slide.new(@clock, [@left_border, @right_border], self)
    @clock_expand_animation ||= Expand.new(@clock)
    @clock_color_change_animation ||= ColorChange.new(@full_clock, @args)

    
  

    
    
  end

  def clock_animations #Creates an animation for clock, using the Classes for each animation
    
    
  end

  class User
  end

  class ColorChange
  
    def initialize(@args, animated_array)
      @args = args
      @animated_array = animated_array
      @invert_animation ||= false
      @current_element ||= 0
      
    end

    def animation
      current_direction_of_the_animation #determines when the animation goes from left to right or from right to left
      current_element
      current_element_color_change

    end

    def current_direction_of_the_animation
      if @current_element >= 4
        @invert_animation = true
      elsif @current_element <= 0
        @invert_animation = false 
  
      end
    end

    def current_element
      if @args.state.tick_count % 60 == 0
        if @invert_animation
          @current_element -= 1
        else
          @current_element +=1
        end
      end
    end

    def current_element_color_change
      @animated_array.each_with_index do |elements, index|
        if @current_element == index +1 && @args.state.tick_count % 60 == 0
          change_color(@full_clock[index])
        end
      end
    
    end


    def change_color(element) #Helper function, that makes the animation, takes an array and in a loop sequentially randomizes colors from each element from left to right, and then makes them black again from right to left 

    
      element.color.each_with_index do |time, index|
        if !@invert_animation
          element.color[index] = rand(255)
        else 
          element.color[index] = 0
        end
  
      end

    end
  
  end

  

  def current_screen
    current_animation
  
  end
  
  def current_animation
    render_clock
    #bounce_animation(@clock_bounce_animation)
    #slide_animation(@clock_slide_animation)
    #expand_animation(@clock_expand_animation)
    #color_change_animation
    @clock_color_change_animation.animation
    
   
    debug
    
  end
  
  def render_clock
    @args.outputs.labels << @clock.current_time
    
    @full_clock.each do |clock|
      @args.outputs.labels << clock.current_time
    end

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
   #randomize_color
   initiali
   current_animated_element
   randomize_color_animation(@full_clock)
   invert_animation(@full_clock)
   
  
  
  
  end




  def initiali
    
    
    @invert_animation ||= false
    @current_element ||= 0



  
  
  end 
  

  def invert_animation(array)
    if @current_element >= array.size + 1
      @invert_animation = true
    elsif @current_element <= 0
      @invert_animation = false 

    end
  end
  
  def current_animated_element
    if @args.state.tick_count % 60 == 0
      if @invert_animation == false
        @current_element += 1
      else
        @current_element -=1
      end
    end
  end

  def randomize_color_animation(array)
    array.each_with_index do |elements, index|
      if @current_element == index +1 && @args.state.tick_count % 60 == 0
        random_color(@full_clock[index])
      end
    end
  
  end

  def color_change_timing
    
  end

  def random_color(element) #Helper function, that makes the animation, takes an array and in a loop sequentially randomizes colors from each element from left to right, and then makes them black again from right to left 

    
    element.color.each_with_index do |time, index|
      if !@invert_animation
        element.color[index] = rand(255)
      else 
        element.color[index] = 0
      end
  
    end

  end

  #Main helper functions


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