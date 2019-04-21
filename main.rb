require 'gosu'
require_relative 'EntityManager'
require_relative 'Components'
require_relative 'Systems'

class Main < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "ECS"
    @e_mng = EntityManager.new
    @e_mng.create_entity("Ball")
    br1 = Renderable.new("images/pear.jpg", 0)
    bl1 = Location.new(1, 1, 0, 0)
    @e_mng.add_component("Ball", br1)
    @e_mng.add_component("Ball", bl1)
    @render = Render.new
  end

  def update
  end

  def draw
    puts "Entities: #{@e_mng.entity_list}"
    @render.process_tick(@e_mng)
    # image = Gosu::Image.new("images/pear.jpg")
    # image.draw_rot(100, 175, 1, 0)
  end

  def button_down(id)
   if id == Gosu::KB_ESCAPE
     close
   else
     super
   end
  end
end

Main.new.show
