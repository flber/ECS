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
      image.draw_rot(x, y, render_comp.zorder, angle)
    end
  end

end

#=================================================

class Physics < System

  def process_tick(ent_mng)
    ent_mng.entities_with_component(RigidBody).each do |e|
      rbod_comp = ent_mng.get_component(e, RigidBody)
      #Simulate physics here, basically just add velocity to position
      #and check for collisions
    end
  end

end

#=================================================

class Gravity < System

  ACCELERATION = 0.6

  def process_tick(ent_mng)
    ent_mng.entities_with_component(AffectedByGravity).each do |e|
      rBody_comp = ent_mng.get_component(e, RigidBody)
      rBody_comp.shape.body.apply_force(-rBody_comp.shape.body.rot * (1000.0/SUBSTEPS), CP::Vec2.new(0.0, 0.0))
    end
  end

end
