require 'gosu'
require 'chunky_png'
require 'chipmunk'
require_relative 'EntityManager'
require_relative 'Components'
require_relative 'Systems'

$width = 640
$height = 480
SUBSTEPS = 6

module ZOrder
  Default = 1
end

class Main < (Eaxample rescue Gosu::Window)
  def initialize
    @space = Array.new($width){Array.new($height){Array.new(){}}}
    super $width, $height
    self.caption = "ECS"
    @e_mng = EntityManager.new
    [-1, 1].each do |i|
      @e_mng.create_entity("Ball#{i}")
      @e_mng.add_component("Ball#{i}", Renderable.new("images/ball.png", 0, 1))
      @e_mng.add_component("Ball#{i}", Location.new(320+(220*i), 200, 10*-i, -7))
      @e_mng.add_component("Ball#{i}", AffectedByGravity.new)
      @e_mng.add_component("Ball#{i}", Collides.new(@e_mng.get_component_with_tag("Ball#{i}", Renderable).chunk_image))
    end
    @e_mng.create_entity("Wall")
    @e_mng.add_component("Wall", Renderable.new("images/wall.png", 0, 1))
    @e_mng.add_component("Wall", Location.new(300, 250, 0, 0))
    @e_mng.add_component("Wall", Collides.new(@e_mng.get_component_with_tag("Wall", Renderable).chunk_image))
    @render = Render.new
    @acceleration = Acceleration.new
    @gravity = Gravity.new
    @collisions = Collisions.new
  end

  def update
  end

  def draw
    @gravity.process_tick(@e_mng)
    @space = @collisions.process_tick(@e_mng, @space)
    @acceleration.process_tick(@e_mng)
    @render.process_tick(@e_mng)
  end

  def button_down(id)
   if id == Gosu::KB_ESCAPE
     close
   else
     super
   end
  end
end

Main.new.show if __FILE__ == $0
