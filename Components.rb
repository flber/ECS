class Component
  attr_reader :id

  def initialize
    @id = rand(0..1000000)
  end

  def to_s
    return self.class.name
  end

end

#=================================================

class Renderable < Component
  attr_reader :image, :rotation, :width, :height, :zorder

  def initialize(file_name, rot, zorder)
    @zorder = zorder
    @image = Gosu::Image.new(file_name)
    @rotation = rot
    chunk_image = ChunkyPNG::Image.from_file(file_name)
    @width = chunk_image.width
    @height = chunk_image.height
  end

end

#=================================================

class Location < Component
  attr_accessor :x, :y

  def initialize(x, y, dx, dy)
    @x = x
    @y = y
  end

end

#=================================================

class AffectedByGravity < Component
end

#=================================================

class Movement < Component
end

#=================================================

class BouncesOnEdge < Component
end

#=================================================

class RigidBody < Component
  attr_reader :p
  attr_accessor :v, :a, :shape

  def initialize(body, shape_array, pos)
    @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    @p = @shape.body.p = pos
    @v = @shape.body.v = CP::Vec2.new(0.0, 0.0)
    @a = @shape.body.a = (3*Math::PI/2.0)
  end

end
