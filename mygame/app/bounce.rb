
class Bounce
  attr_accessor :animated_object
    def initialize(object, borders, main)
      @animated_object = object
      @borders = borders
      @main = main
      
    end

    def animate
      initial_movement
      bounce
    end

    def initial_movement
      @animated_object.x_pos += @animated_object.horizontal_speed
      @animated_object.y_pos += @animated_object.vertical_speed 
    end

    def bounce_trayectory(border, object)
      

      if border.bounce_angle == "Vertical"
        object.vertical_speed *= REVERSE_TRAYECTORY
      else
        object.horizontal_speed *= REVERSE_TRAYECTORY
          
      end
    end

    def bounce
      @borders.each do |border|
        if @main.collision(border, @animated_object)
          bounce_trayectory(border, @animated_object)
        end
      end
    end

  end