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

    @e_mng.create_entity("Space")
    @e_mng.add_component("Space", Space.new)
    @e_mng.add_component("Space", GravDir.new(0, 0.6))
    @e_mng.add_component("Space", Resistance.new(0.99))

    [-1, 1].each do |i|
      @e_mng.create_entity("Ball#{i}")
      @e_mng.add_component("Ball#{i}", Renderable.new("images/ball.png", 0, 1))
      @e_mng.add_component("Ball#{i}", Location.new(320+(220*i), 200, 10*-i, -7))
      @e_mng.add_component("Ball#{i}", AffectedByGravity.new)
      chunk_image = @e_mng.get_component_with_tag("Ball#{i}", Renderable).chunk_image
      @e_mng.add_component("Ball#{i}", Collides.new(chunk_image, "Ball#{i}"))
    end

    id_list = []
    @e_mng.entity_list.each do |e|
      id_list << e[0]
    end
    puts "ids: #{id_list}"

    # @e_mng.create_entity("Ball")
    # @e_mng.add_component("Ball", Renderable.new("images/ball.png", 0, 1))
    # @e_mng.add_component("Ball", Location.new(540, 400, -10, -7))
    # @e_mng.add_component("Ball", AffectedByGravity.new)
    # chunk_image = @e_mng.get_component_with_tag("Ball", Renderable).chunk_image
    # @e_mng.add_component("Ball", Collides.new(chunk_image, "Ball"))

    # @e_mng.create_entity("Banana")
    # @e_mng.add_component("Banana", Renderable.new("images/banana.png", 0, 1))
    # @e_mng.add_component("Banana", Location.new(320, 300, 0, -15))
    # @e_mng.add_component("Banana", AffectedByGravity.new)
    # chunk_image = @e_mng.get_component_with_tag("Banana", Renderable).chunk_image
    # @e_mng.add_component("Banana", Collides.new(chunk_image, "Banana"))

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
