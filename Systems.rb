class System

  def process_tick
    raise RuntimeError, "You're doing something wrong!"
  end

end

#=================================================

class Render < System

  def process_tick(ent_mng)
      ent_mng.entities_with_component(Renderable).each do |e|
      render_comp = ent_mng.get_component(e, Renderable)
      loc_comp = ent_mng.get_component(e, Location)
      x = loc_comp.x
      y = loc_comp.y
      angle = render_comp.rotation
      image = render_comp.image
      image.draw_rot(x, y, 1, angle)
    end
  end

end

#=================================================

class Physics < System

  def process_tick(ent_mng)
    ent_mng.entities_with_component(Location).each do |e|
      loc_comp = ent_mng.get_component(e, Location)
      loc_comp.x += loc_comp.dx
      loc_comp.y += loc_comp.dy
    end
    ent_mng.entities_with_component(BouncesOnEdge).each do |e|
      loc_comp = ent_mng.get_component(e, Location)
      rend_comp = ent_mng.get_component(e, Renderable)
      if loc_comp.x - rend_comp.width/2 <= 1 || loc_comp.x + rend_comp.width/2 >= $width - 1
        loc_comp.dx *= -1
        loc_comp.dx *= 0.8
        loc_comp.dy *= 0.8
      end
      if loc_comp.y - rend_comp.height/2 <= 1 || loc_comp.y + rend_comp.height/2 >= $height - 1
        loc_comp.dy *= -1
        loc_comp.dx *= 0.8
        loc_comp.dy *= 0.8
      end
      if loc_comp.x - rend_comp.width/2 < 0
        loc_comp.x = rend_comp.width/2 + 1
      end
      if loc_comp.x + rend_comp.width/2 > $width
        loc_comp.x = $width - (rend_comp.height/2 + 1)
      end
      if loc_comp.y - rend_comp.height/2 < 0
        loc_comp.y = rend_comp.height/2 + 1
      end
      if loc_comp.y + rend_comp.height/2 > $height
        loc_comp.y = $height - (rend_comp.height/2 + 1)
      end
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
