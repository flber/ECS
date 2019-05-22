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
      if ent_mng.has_component_of_type(e, RigidBody)
        render_comp = ent_mng.get_component(e, Renderable)
        rbod_comp = ent_mng.get_component(e, RigidBody)
        image = render_comp.image
        x = rbod_comp.shape.body.p
      end
    end
  end

end

#=================================================

class Physics < System

  def process_tick(ent_mng)
    ent_mng.entities_with_component(RigidBody).each do |e|
      rbod_comp = ent_mng.get_component(e, RigidBody)
      puts "v = #{rbod_comp.shape.body.v}"
      rbod_comp.shape.body.p += rbod_comp.shape.body.v
      #Simulate physics here, basically just add velocity to position
      #and check for collisions
    end
  end

end

#=================================================

class Gravity < System

  ACCELERATION = 0.6

  def process_tick(ent_mng, space)
    ent_mng.entities_with_component(AffectedByGravity).each do |e|
      rbod_comp = ent_mng.get_component(e, RigidBody)
      #space.cpBodyApplyForce(rbod_comp.body, CP::Vec2.new(0,2), 0)
    end
  end

end
