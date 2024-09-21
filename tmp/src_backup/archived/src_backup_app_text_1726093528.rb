class Text 
  attr_accessor :x_pos, :y_pos, :width, :height
  def initialize(args, x, y, size, text ,skip_space=50)
    @args = args
    @x_pos = x
    @y_pos = y 
    @text = text
    @size = size
    @width = (@text.length * 10) + (@text.length * @size)
    @height = (@size * 2)
    @anchor = 1.5
    
    @skip_space = skip_space
    @color = [0, 0, 0]
  end

  def single_line
    return {x: @x_pos, y: @y_pos, size_enum: @size, text: @text, red: @color[0], green: @color[0], blue: @color[0] }
  end

  def multiple_lines
    all_lines = []
    @text.each_with_index do |text, index|
      all_lines << {x: @x_pos, y:@y_pos + (index * @skip_space) , anchor_x: @anchor, anchor_y: @anchor, text: text}
    end
    return all_lines
    
  end

  def draw_single_line
    @args.outputs.labels << {x: @x_pos, y: @y_pos, size_enum: @size, text: @text, red: @color[0], green: @color[0], blue: @color[0] }
  end
  
  def draw_multiple_lines
    @text.each_with_index do |text, index|
      @args.outputs.labels << {x: @x_pos, y:@y_pos + (index * @skip_space) , anchor_x: @anchor, anchor_y: @anchor, text: text}
    end
  end

  def hitbox 
    hitbox = []
    
    @text.each_with_index do |text, index|
      hitbox << { x:@x_pos, y: (@y_pos - height) + (index * @skip_space), w: text.count("A-Za-z0-9") * @size, h: @height}
    end
    return hitbox
  end
   
end