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
      x = render_comp.x
      y = render_comp.y
      angle = render_comp.rotation
      e.image.draw_rot(x, y, 1, angle)
    end
  end

end
