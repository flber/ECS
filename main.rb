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
    (0..30).each do |i|
      @e_mng.create_entity("Ball#{i}")
      @e_mng.add_component("Ball#{i}", Renderable.new("images/ball.png", 0))
      @e_mng.add_component("Ball#{i}", Location.new(rand(100..540), rand(100..380), rand(-15..15), -20))
      @e_mng.add_component("Ball#{i}", AffectedByGravity.new)
      @e_mng.add_component("Ball#{i}", BouncesOnEdge.new)
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
    @gravity.process_tick(@e_mng)
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
