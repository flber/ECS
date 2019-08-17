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
    @font = Gosu::Font.new(20)
    @space = Array.new($width){Array.new($height){Array.new(){}}}
    super $width, $height
    self.caption = "ECS"
    @e_mng = EntityManager.new

    @e_mng.create_entity("Space")
    @e_mng.add_component("Space", Space.new)
    @e_mng.add_component("Space", GravDir.new(0, 0.6))
    @e_mng.add_component("Space", Resistance.new(0.99))
    # @e_mng.add_component("Space", Location.new(320, 240, 0, 0))
    # @e_mng.add_component("Space", Renderable.new("images/space_test.png", 0, 0))
    # chunk_image = @e_mng.get_component_with_tag("Space", Renderable).chunk_image
    # @e_mng.add_component("Space", Collides.new(chunk_image, "Space"))

    @ball_chunk_image = ChunkyPNG::Image.from_file("images/ball.png")
    @banana_chunk_image = ChunkyPNG::Image.from_file("images/banana.png")

    @e_mng.create_entity("Ball_1")
    components = [Renderable.new("images/ball.png", 0, 1),
                  Location.new(200, 200, 8.0, 0),
                  AffectedByGravity.new,
                  Collides.new(@ball_chunk_image, "Ball_1")]
    @e_mng.add_components("Ball_1", components)

    @e_mng.create_entity("Ball_2")
    components1 = [Renderable.new("images/ball.png", 0, 1),
                  Location.new(480, 200, -8.0, 0),
                  AffectedByGravity.new,
                  Collides.new(@ball_chunk_image, "Ball_1")]
    @e_mng.add_components("Ball_2", components1)

    @e_mng.create_entity("Banana")
    components2 = [Renderable.new("images/banana.png", 0, 1),
                  Location.new(295, 270, 0, 0),
                  Collides.new(@banana_chunk_image, "Ball_1"),
                  Stationary.new]
    @e_mng.add_components("Banana", components2)

    @render = Render.new
    @acceleration = Acceleration.new
    @gravity = Gravity.new
    @collisions = Collisions.new
    # @move = Move.new
  end

  def update
    ban_loc = @e_mng.get_component_with_tag("Banana", Location)
    ban_loc.x = mouse_x
    ban_loc.y = mouse_y
    # id = @e_mng.id_at_tag["Space"]
    # @e_mng.get_component(id, GravDir).x_vel = (mouse_x - $width/2)/1000
    # @e_mng.get_component(id, GravDir).y_vel = (mouse_y - $height/2)/1000
  end

  def draw
    @font.draw("x: #{mouse_x}", 10, 10, 5, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw("x: #{mouse_y}", 10, 30, 5, 1.0, 1.0, Gosu::Color::YELLOW)
    @gravity.process_tick(@e_mng)
    # @move.process_tick(@e_mng)
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

  def needs_cursor?
    true
  end
end

Main.new.show if __FILE__ == $0
