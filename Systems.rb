class System

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

  def process_tick(ent_mng)
    ent_mng.entities_with_component(Collides).each do |e|
      if ent_mng.has_component_of_type(e, Renderable)
        col_comp = ent_mng.get_component(e, Collides)
        render_comp = ent_mng.get_component(e, Renderable)
        if col_comp.shape == "ball"
          
        end
        if col_comp.shape == "rect"

        end
      end
    end
  end

end
