class ColorChange
  
  def initialize(args, animated_array)
    @args = args
    @animated_array = animated_array
    @invert_animation ||= false
    @current_element ||= 0
    
  end

  def animate
    current_direction_of_the_animation #determines when the animation goes from left to right or from right to left
    current_element
    current_element_color_change

  end

  def current_direction_of_the_animation
    if @current_element > @animated_array.size 
      @invert_animation = true
    elsif @current_element <= 0
      @invert_animation   = false
    end
  end

  def current_element
    if a_second_passed
      if @invert_animation
        @current_element -= 1
      else
        @current_element +=1
      end
    end
  end

  def current_element_color_change
    @animated_array.each_with_index do |elements, index|
      if @current_element == index +1 && a_second_passed
        change_color(@animated_array[index])
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

  def a_second_passed
    @args.state.tick_count % 60 == 0
  end  
end