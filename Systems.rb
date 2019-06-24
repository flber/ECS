module Checks
  def inWindow(x, y)
    return x > 0 && x < $width &&
           y > 0 && y < $height
  end
end

class System

  include Checks

  def process_tick
    raise RuntimeError, "You're doing something wrong!"
  end

end

#=================================================

class Render < System

  def process_tick(ent_mng)
    ent_mng.entities_with_component(Renderable).each do |e|
      if ent_mng.has_component_of_type(e, Location)
        render_comp = ent_mng.get_component(e, Renderable)
        loc_comp = ent_mng.get_component(e, Location)
        x = loc_comp.x
        y = loc_comp.y
        angle = render_comp.rotation
        image = render_comp.image
        image.draw_rot(x, y, render_comp.zorder, angle)
      end
    end
  end

end

#=================================================

class Acceleration < System

  def process_tick(ent_mng)
    ent_mng.entities_with_component(Location).each do |e|
      loc_comp = ent_mng.get_component(e, Location)
      loc_comp.x += loc_comp.dx
      loc_comp.y += loc_comp.dy
    end
  end

end

#=================================================

class Gravity < System

  ACCELERATION = 0.6

  def process_tick(ent_mng)
    ent_mng.entities_with_component(AffectedByGravity).each do |e|
      loc_comp = ent_mng.get_component(e, Location)
      loc_comp.dy += ACCELERATION
    end
  end

end

#=================================================

class Collisions < System

  def process_tick(ent_mng, space)
    space.clear
    space = Array.new($width){Array.new($height){Array.new(){}}}
    ent_mng.entities_with_component(Collides).each do |e|
      if ent_mng.has_component_of_type(e, Renderable)
        col_comp = ent_mng.get_component(e, Collides)
        @shape = col_comp.shape
        render_comp = ent_mng.get_component(e, Renderable)
        loc_comp = ent_mng.get_component(e, Location)
        #add current points
        @shape.each do |point|
          x = point[0] - 25 + loc_comp.x
          y = point[1] - 50 + loc_comp.y
          if inWindow(x, y)
            space[x][y] << e
          end
        end
        @shape.each do |point|
          x = point[0] - 25 + loc_comp.x
          y = point[1] - 50 + loc_comp.y
          if inWindow(x, y) && space[x][y].length > 1
            o_id = 0
            space[x][y].each do |id|
              if id != e
                o_id = id
              end
            end
            o_id_loc = ent_mng.get_component(o_id, Location)
            change_x = o_id_loc.dx/2
            change_y = o_id_loc.dy/2
            ent_mng.get_component(o_id, Location).dx -= change_x
            ent_mng.get_component(o_id, Location).dy -= change_y
            loc_comp.dx += change_x
            loc_comp.dy += change_y
          end
        end
      end
    end
    return space
  end

end
