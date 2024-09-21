$gtk.reset

require "app/all_files.rb"

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
REVERSE_TRAYECTORY = -1 
ALL_COLORS = 255

#Arreglar el clock hitbox en la animación de expand para que se expanda tambiéon, o que en esa animaciuón no aparezca
#Ver si puedo unificar los relojes 
#Cambiar el nombre de important functions
#Unir tal vez clock y text sería la solución?`
#Ver si puedo encontrar la manera de hacer de width un atributo
#Regresar al reloj a su estado inicial_antes de iniciar otra animación

class TimeAnimation
  def initialize(args)
    @args = args
    @time = Time.new
    
    @clock_hour = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@time.hour}")
    @clock_colon = Clock.new(HALF_SCREEN_WIDTH + @clock_hour.width, HALF_SCREEN_HEIGHT, ":")
    @clock_minutes = Clock.new(HALF_SCREEN_WIDTH + @clock_hour.width + @clock_colon.width, HALF_SCREEN_HEIGHT, "#{@time.min}")
    
    @clock = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@clock_hour.time}" + "#{@clock_colon.time}" + "#{@clock_minutes.time}")

    @full_clock = [@clock_hour, @clock_colon, @clock_minutes]
    
    
   

    @animation ||= nil
    
  end



  def current_screen
    important_objects
    render_clock
    render_options
    current_animation
    
    debug
   
  
  end

  def important_objects # rename
    clock_objects
    screen_borders
    clock_animations
    option_select
  end
  
  def clock_objects
    
  end
  
  def clock_animations #Creates an animation for clock, using the Classes for each animation
    
    @clock_bounce ||= Bounce.new(@clock, [@left_border, @right_border, @top_border, @bottom_border], self) 
    @clock_slide ||= Slide.new(@clock, [@left_border, @right_border], self)
    @clock_expand ||= Expand.new(@clock)
    @clock_color_change ||= ColorChange.new(@args, @full_clock) #Takes an array to animate each element individually
    
  end

  def screen_borders
    @bottom_border = Borders.new(0, 50, SCREEN_WIDTH, 10, "Vertical")
    @top_border = Borders.new(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0, "Vertical")
    @left_border = Borders.new(0, 0, 0, SCREEN_HEIGHT, "Horizontal")
    @right_border = Borders.new(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT, "Horizontal")
  end
  

  def reset_clock_after_changing_animation
   
  end



  def animation_options
    options = {"Bounce" => @clock_bounce, "Slide" => @clock_slide, "Expand" => @clock_expand, "Color Change" => @clock_color_change, "Reset" => 'Reset'}

    return options
  end

  def option_select #Depende de animation_option 1, depende de mouse_click 1
    @option_select = Text.new(@args, 1, 100, 10, animation_options.keys)
    @selected_option ||= ''    

    @option_select.text_clicked.each do |option|
      if mouse_click(option)
        @selected_option = option.text
      end
    end
    
  end

  def current_animation #Depende de option_select 2, depende de current_animation 0 
    animation_options.each_pair do |key, value|
      if @selected_option == key
        current_animation(value)
      
      end
    end
  end


  
  def render_clock #Depende de clock 5
    @args.outputs.labels << @clock.current_time
    
    @full_clock.each do |clock|
     @args.outputs.labels << clock.current_time
    end

    @args.outputs.borders << @clock.clock_hitbox
  end

 

  def render_options
    animation_options
    @option_select.multiple_lines

    


    
  end

  def selected_animation(animated_object)
    animated_object.animate
  end


  

  #Helper functions
 

  def mouse_click(box)
    if @args.inputs.mouse.click
      if mouse_point(box)
        return true
      end
    end
  end

  def key_pressed(key_action, key, output)
    if @args.inputs.keyboard.send(key_action).send(key)
      call(output)
    end
  end

  def mouse_point(box)
    
    mouse = @args.inputs.mouse.point
    
    mouse[:x] >= box[:x] && mouse[:x] <= box[:x] + box[:w] &&
    mouse[:y] >= box[:y] && mouse[:y]  <= box[:y] + box[:h]
    
  end
  
  def collision(box1, box2) #box1 border, box 2 clock
    box1.y_pos <= box2.y_pos &&  
    box1.y_pos + box1.height >= box2.y_pos  &&
    box1.x_pos <= box2.x_pos + box2.width &&
    box1.x_pos + box1.width >= box2.x_pos 
  end

  def debug 
    debug_text =  ["#{@selected_option}" ]
    Text.new(@args, HALF_SCREEN_WIDTH, 600, 10,  debug_text,).multiple_lines

    test = {x: HALF_SCREEN_WIDTH, y: 200, w: 100, h: 100}



   
  end

  def tick
    important_objects
    current_screen
    
  end

end

def tick (args)
 args.state.time_animation ||= TimeAnimation.new(args)
 args.state.time_animation.tick
end