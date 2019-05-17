require 'gosu'
require 'chunky_png'
require_relative 'EntityManager'
require_relative 'Components'
require_relative 'Systems'

$width = 640
$height = 480

class Main < Gosu::Window
  def initialize
    super $width, $height
    self.caption = "ECS"
    @e_mng = EntityManager.new
    @e_mng.create_entity("Ball")
    @e_mng.add_component("Ball", Renderable.new("images/ball.png", 0))
    @e_mng.add_component("Ball", Location.new(300, 200, 5, -10))
    @e_mng.add_component("Ball", AffectedByGravity.new)
    @e_mng.add_component("Ball", BouncesOnEdge.new)
    @render = Render.new
    @physics = Physics.new
    @gravity = Gravity.new
  end

  def update
  end

  def draw
    @render.process_tick(@e_mng)
    @physics.process_tick(@e_mng)
    @gravity.process_tick(@e_mng)
  end

  def button_down(id)
   if id == Gosu::KB_ESCAPE
     close
   else if id == Gosu::KB_SPACE
     #add vertical velocity to ball?
   else
     super
   end
  end
end

Main.new.show
