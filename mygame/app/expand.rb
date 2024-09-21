class Expand
  attr_accessor :animated_object
  def initialize(animated_object)
    @animated_object = animated_object
  end

  def animate
    expand_and_retract
    size_limits
  end

  def expand_and_retract
    @expand_object ||= false

    if !@expand_object
      retract
    else
      expand
    end
  end

  def size_limits
    if @animated_object.size >= 80
      @expand_object = false
    elsif @animated_object.size <= 5
      @expand_object = true
    end
  end

  def expand 
    @animated_object.size += 1
  end

  def retract
    @animated_object.size -= 1 
  end
end