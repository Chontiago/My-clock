$gtk.reset

class TimeAnimation
  def initialize(args)
    @args = args
  end

  def tick
  end
  
 
end

def tick (args)
 args.state.time_animation ||= TimeAnimation.new(args)
 args.state.time_animation.tick
end