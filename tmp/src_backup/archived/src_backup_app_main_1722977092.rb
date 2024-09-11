$gtk.reset

class TimeAnimation
  def initialize(args)
    @args = args
  end
  
 
end

def tick (args)
 args.state.time_animation ||= TimeAnimation.new(args)
end