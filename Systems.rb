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
    component_list = [Renderable, Location]
    ent_mng.entities_with_components(component_list).each do |e|
      if ent_mng.has_component_of_type(e, Location) #&& !ent_mng.has_component_of_type(e, Space)
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
      # this really should be in the collision system...
      #
      # components = [Space, Resistance]
      # ent_mng.entities_with_components(components).each do |s|
      #   puts "space: #{s}"
      #   res_comp = ent_mng.get_component(s, Resistance)
      #   puts "resistance: #{res_comp}"
      #   loc_comp.dx *= res_comp.res
      #   loc_comp.dy *= res_comp.res
      # end
      if !ent_mng.has_component_of_type(e, Stationary)
        loc_comp.x += loc_comp.dx
        loc_comp.y += loc_comp.dy
      end
    end
  end

end

#=================================================

class Gravity < System

  def process_tick(ent_mng)
    # ent_mng.entities_with_component(Space).each do |s|
    #   grav_comp = ent_mng.get_component(s, GravDir)
    #   x_vel = grav_comp.x_vel
    #   y_vel = grav_comp.y_vel
    #   component_list = [AffectedByGravity, Location]
    #   ent_mng.entities_with_components(component_list).each do |e|
    #     loc_comp = ent_mng.get_component(e, Location)
    #     loc_comp.dx += x_vel
    #     loc_comp.dy += y_vel
    #   end
    # end
  end

end

#=================================================

class Collisions < System

  def process_tick(ent_mng, space)
    space.clear
    space = Array.new($width){Array.new($height){Array.new(){}}}
    component_list = [Collides, Location, Renderable]
    ent_mng.entities_with_components(component_list).each do |e|
      # puts "e: #{e}"
      if ent_mng.has_component_of_type(e, Space)
        col_comp = ent_mng.get_component(e, Collides)
        loc_comp = ent_mng.get_component(e, Location)
        int_shape = col_comp.shape_interior
        int_shape.each do |point|
          x = point[0] - 25 + loc_comp.x
          y = point[1] - 50 + loc_comp.y
          if inWindow(x, y)
            #puts "#{e}"
            space[x][y] << "i#{e}"
          end
        end
      else
        hit_stop = false
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
        # puts "@shape: #{@shape}"
        @shape.each do |point|
          x = point[0] - 25 + loc_comp.x
          y = point[1] - 50 + loc_comp.y
          if inWindow(x, y) && space[x][y].length > 1
            o_id = 0
            space[x][y].each do |id|
              if id != e && !hit_stop # if you've hit a different shape and you haven't hit one before
                o_id = id # save the id of the other shape
                if o_id.to_s[0..0] == "i" # if the id has an "i" as the first letter
                  space_id = o_id[1..o_id.length].to_i # find the actual id (sans "i")
                  space_res = ent_mng.get_component(space_id, Resistance)
                  space_grav = ent_mng.get_component(space_id, GravDir)
                  x_vel = space_grav.x_vel
                  y_vel = space_grav.y_vel
                  res = space_res.res
                  loc_comp.dx -= res
                  loc_comp.dy -= res
                  loc_comp.dx += x_vel
                  loc_comp.dy += y_vel
                else
                  if ent_mng.has_component_of_type(o_id, Stationary)
                    loc_comp.dx *= -1.0
                    loc_comp.dy *= -1.0
                  end
                  if ent_mng.has_component_of_type(e, Stationary)
                    o_id_loc = ent_mng.get_component(o_id, Location) # get the other shape's Loc
                    o_id_loc.dx *= -1.0
                    o_id_loc.dy *= -1.0
                  else
                    o_id_loc = ent_mng.get_component(o_id, Location) # get the other shape's Loc
                    this_change_x = loc_comp.dx/2.0
                    this_change_y = loc_comp.dy/2.0
                    other_change_x = o_id_loc.dx/2.0
                    other_change_y = o_id_loc.dy/2.0

                    o_id_old_dx = o_id_loc.dx # this is just to get an output that's accurate
                    o_id_loc.dx -= other_change_x
                    o_id_loc.dy -= other_change_y
                    loc_comp.dx -= this_change_x
                    loc_comp.dy -= this_change_y

                    o_id_loc.dx += this_change_x
                    o_id_loc.dy += this_change_y
                    loc_comp.dx += other_change_x
                    loc_comp.dy += other_change_y
                  end
                end
              else
                hit_stop = true
                # puts "NO HIT! -------------------------------"
              end
            end
          end
        end
      end
    end
    return space
  end

end

#=================================================

class Move < System

  def process_tick(ent_mng)
    components = [Player, Location]
    ent_mng.entities_with_components(components).each do |e|
      player_comp = ent_mng.get_component(e, Player)
      loc_comp = ent_mng.get_component(e, Location)
      puts "player comp up: #{player_comp.up}"
      if button_down?(player_comp.up)
        loc_comp.dy -= 2
      end
      if button_down?(player_comp.left)
        loc_comp.dx -= 2
      end
      if button_down?(player_comp.down)
        loc_comp.dy += 2
      end
      if button_down?(player_comp.right)
        loc_comp.dx += 2
      end
    end
  end

end
