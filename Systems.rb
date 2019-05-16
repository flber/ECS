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
      puts "Drawn!"
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
      puts "Physics!"
    end
    ent_mng.entities_with_component(BouncesOnEdge).each do |e|
      loc_comp = ent_mng.get_component(e, Location)
      rend_comp = ent_mng.get_component(e, Renderable)
      if true

      end
      puts "Physics!"
    end
  end

end

#=================================================

class Gravity < System

  ACCELERATION = 0.05

  def process_tick(ent_mng)
    ent_mng.entities_with_component(AffectedByGravity).each do |e|
      loc_comp = ent_mng.get_component(e, Location)
      loc_comp.dy += ACCELERATION
      puts "Physics!"
    end
  end

end
