class Text 
  attr_accessor :x_pos, :y_pos
  def initialize(args, x, y, size, text ,skip_space=50)
    @args = args
    @x_pos = x
    @y_pos = y 
    @size = size
    @anchor = 1.5
    @text = text
    @skip_space = skip_space
    @color = [0, 0, 0]
  end

  def single_line
    return {x: @x_pos, y: @y_pos, size_enum: @size, text: @text, red: @color[0], green: @color[0], blue: @color[0] }
  end

  def multiple_lines
    array = []
    @text.each_with_index do |text, index|
      array << {x: @x_pos, y:@y_pos + (index * @skip_space) , anchor_x: @anchor, anchor_y: @anchor, text: text}
    end
    return array
    
  end

  def render_single_line
    @args.outputs.labels << {x: @x_pos, y: @y_pos, size_enum: @size, text: @text, red: @color[0], green: @color[0], blue: @color[0] }
  end
  
  def render_multiple_lines
    @text.each_with_index do |text, index|
      @args.outputs.labels << {x: @x_pos, y:@y_pos + (index * @skip_space) , anchor_x: @anchor, anchor_y: @anchor, text: text}
    end
  end
   
end