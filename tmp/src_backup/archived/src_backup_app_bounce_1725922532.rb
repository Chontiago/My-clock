
class Bounce
    def initialize(bouncing_object, borders, main)
      @bouncing_object = bouncing_object
      @borders = borders
      @main = main
      
    end

    def animate
      initial_movement
      bounce
    end

    def initial_movement
      @bouncing_object.x_pos += @bouncing_object.horizontal_speed
      @bouncing_object.y_pos += @bouncing_object.vertical_speed 
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
        if @main.collision(border, @bouncing_object)
          bounce_trayectory(border, @bouncing_object)
        end
      end
    end

  end