class System

  def process_tick
    raise RuntimeError, "You're doing something wrong!"
  end

end

#=================================================

class Render < System

  def process_tick(ent_mng)
    puts "checking"
    puts "With renderable: #{ent_mng.entities_with_component(Renderable)}"
    ent_mng.entities_with_component(Renderable).each do |e|
      render_comp = ent_mng.get_component(e, Renderable)
      loc_comp = ent_mng.get_component(e, Location)
      x = loc_comp.x
      y = loc_comp.y
      angle = render_comp.rotation
      file = render_comp.image_loc
      image = Gosu::Image.new(file)
      image.draw_rot(x, y, 1, angle)
      puts "Drawn!"
    end
  end

end
