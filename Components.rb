class Component
  attr_reader :id

  def initialize
    @id = SecureRandom.uuid
  end

  def to_s
    return self.class.name
  end

end

#=================================================

class Renderable < Component
  attr_reader :image_loc, :rotation

  def initialize(file_name, rot)
    @image_loc = file_name
    @rotation = rot
  end

end

#=================================================

class Location < Component
  attr_reader :x, :y, :dx, :dy

  def initialize(x, y, dx, dy)
    @x = x
    @y = y
    @dx = dx
    @dy = dy
  end

end

#=================================================

class AffectedByGravity < Component
end

#=================================================

class Movement < Component
end
