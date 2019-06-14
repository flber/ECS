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
  attr_accessor :x, :y, :dx, :dy

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

#=================================================

class Collides < Component
  attr_reader :shape

  def initialize(shape)
    @shape = shape
  end

end

#=================================================

# I don't like this and it's super gross, so I'm just going to write my own collision
# class RigidBody < Component
#   attr_accessor :shape, :body, :image
#
#   def initialize(image_file, x, y, zorder)
#     @zorder = zorder
#     @image = Gosu::Image.new(image_file)
#     @chunk_image = ChunkyPNG::Image.from_file(image_file)
#     @width = @chunk_image.width
#     @height = @chunk_image.height
#     @shape_array = []
#     (0..6).each do |x|
#       @shape_array << CP::Vec2.new(Math.cos(x)*(@width/2), Math.sin(x)*(@height/2))
#     end
#     puts @shape_array
#     @body = CP::Body.new(x, y)
#     @shape = CP::Shape::Poly.new(@body, @shape_array, CP::Vec2.new(0, 0))
#   end
#
#   def create_shape
#     shape_array = []
#     (0..@width).each do |r|
#       (0..@height).each do |c|
#          if @chunk_image.get_pixel(r, c).to_s != "0"
#            shape_array.push CP::Vec2.new(r, c)
#            while(@chunk_image.get_pixel(r, c).to_s != "")
#              #puts "at r, c = #{@chunk_image.get_pixel(r, c).to_s}"
#              c+=1;
#              puts "c: #{c}"
#              break if c > @height
#            end
#            shape_array.push CP::Vec2.new(r, c)
#          end
#       end
#     end
#     return shape_array
#   end
#
# end
