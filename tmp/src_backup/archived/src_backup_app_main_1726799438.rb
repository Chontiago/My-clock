$gtk.reset

require "app/all_files.rb"

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2 
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
REVERSE_TRAYECTORY = -1 
ALL_COLORS = 255


class TimeAnimation
  def initialize(args)
    @args = args
    @time = Time.new
    @clock_hour = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@time.hour}")
    @clock_colon = Clock.new(HALF_SCREEN_WIDTH + @clock_hour.width, HALF_SCREEN_HEIGHT, ":")
    @clock_minutes = Clock.new(HALF_SCREEN_WIDTH + @clock_hour.width + @clock_colon.width, HALF_SCREEN_HEIGHT, "#{@time.min}")
    @clock_2 = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{@clock_hour.current_time}" + "#{@clock_colon.time}" + "#{@clock_minutes.time}")
    @full_clock = [@clock_hour, @clock_colon, @clock_minutes]
    
    @full_clock.each do |clock|
      @clock = Clock.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, "#{clock.current_time[:text]}")
    end
    
    @clock_array ||= [@clock]
   
    
  end

#OBJECTS

  
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
  
  def animation_select_options
    all_animation_options = {"Bounce" => @clock_bounce, "Slide" => @clock_slide, "Expand" => @clock_expand, "Color Change" => @clock_color_change}
    @all_animation_options_text = Text.new(@args, 1, 100, 10, all_animation_options.keys)
    
    @animation_select ||= AnimationSelect.new(all_animation_options, @all_animation_options_text, self)
  end

  #MAIN CODE

  def current_screen
    important_objects
    render_clock
    render_options
    current_animation
  
  end

  def important_objects # rename
    screen_borders
    clock_animations
    animation_select_options
   
  end


  def current_animation
    @animation_select.selected_option
    @animation_select.current_animation
  
  end
  
  def render_clock 
    #@clock_array.each do |clock|
     # @args.outputs.labels << clock.current_time
    #end

    @full_clock.each do |clock|
      @args.outputs.labels << clock.current_time
    end

    reset_clock_defaults_when_changing_animation
    
  end

  def render_options
    @all_animation_options_text.multiple_lines
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

  def reset_clock_defaults_when_changing_animation
    if @animation_select.current_animation_playing == 'Color Change'
      @clock_array = @full_clock
    else
      @clock_array = [@clock]
      reset(@clock)
    end
  end 

  def reset(object) 
    if @animation_select.reset == true
      object.reset_defaults
      @animation_select.reset = false
    end
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