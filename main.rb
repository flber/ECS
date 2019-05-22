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
    super $width, $height
    self.caption = "ECS"
    @e_mng = EntityManager.new
    @dt = (1.0/60.0)
    @space = CP::Space.new
    @space.damping = 0.8
    (0..15).each do |i|
      body = CP::Body.new(10.0, 150.0)
      shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
      shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
      @e_mng.create_entity("Ball#{i}")
      #@e_mng.add_component("Ball#{i}", Renderable.new("images/ball.png", 0, 1))
      #@e_mng.add_component("Ball#{i}", Location.new(rand(100..540), rand(100..380), rand(-15..15), -20))
      @e_mng.add_component("Ball#{i}", RigidBody.new("images/ball.png", rand(100..540), rand(100..380), 1))
      @e_mng.add_component("Ball#{i}", AffectedByGravity.new)
      @e_mng.add_component("Ball#{i}", BouncesOnEdge.new)
      @space.add_body(body)
      @space.add_shape(shape)
    end
    @render = Render.new
    @physics = Physics.new
    @gravity = Gravity.new
  end

  def update
  end

  def draw
    @render.process_tick(@e_mng)
    @physics.process_tick(@e_mng)
    @gravity.process_tick(@e_mng, @space)
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
