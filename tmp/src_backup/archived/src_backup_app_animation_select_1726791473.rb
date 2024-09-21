class AnimationSelect
  attr_accessor :reset
  def initialize(options_hash, options_object, main)
    @options_hash = options_hash
    @options_object = options_object
    @animations = options_hash.values
    @main = main
    @reset = false
  end

  def selected_option
    
    @selected_option ||= ''
    @options_object.clikcked_text.each do |option|
      if @main.mouse_click(option)
        @reset = true
        @selected_option = option.text
      end
    end
  end

  def current_animation
    @options_hash.each_pair do |animation_key, animation|
      if @selected_option == animation_key
        selected_animation(animation)
      end
    end
  end

  def current_animation_playing
    return @selected_option
  end

  def animation_change
    if @selected_option != @selected_option
      return true 
    end
  end


  def selected_animation(animation)
    animation.animate
  end

end