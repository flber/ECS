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
  attr_reader :image, :rotation, :width, :height, :zorder, :chunk_image

  def initialize(file_name, rot, zorder)
    @zorder = zorder
    @image = Gosu::Image.new(file_name)
    @rotation = rot
    @chunk_image = ChunkyPNG::Image.from_file(file_name)
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

  def initialize(chunk_image)
    @cimg = chunk_image
    @width = chunk_image.width
    @height = chunk_image.height
    @shape = Array.new(){}
    # puts "setting up shape"
    left_to_right
    right_to_left
    up_to_down
    down_to_up
    verify_shape
    # puts "shape: #{@shape}"
    # png = ChunkyPNG::Image.new($width, $height, ChunkyPNG::Color::WHITE)
    # @shape.each do |point|
    #   x = point[0]
    #   y = point[1]
    #   png[x, y] = ChunkyPNG::Color.rgba(0, 0, 0, 128)
    # end
    # png.save('images/test.png', :interlace => true)
  end

  def left_to_right
    y = 0
    while y < @height
      count = 0
      x = 0
      while x < @width && count < 3
        if @cimg.get_pixel(x, y) != 0
          @shape << [x,y]
          count += 1
        end
        x += 1
      end
      y += 1
    end
    # puts "l to r done!"
  end

  def right_to_left
    y = @height
    while y > 0
      count = 0
      x = @width
      while x > 0 && count < 3
        if @cimg.get_pixel(x, y) != 0
          @shape << [x,y]
          count += 1
        end
        x -= 1
      end
      y -= 1
    end
    # puts "r to l done!"
  end

  def up_to_down
    x = 0
    while x < @height
      count = 0
      y = 0
      while y < @width && count < 3
        if @cimg.get_pixel(x, y) != 0
          @shape << [x,y]
          count += 1
        end
        y += 1
      end
      x += 1
    end
    # puts "u to d done!"
  end

  def down_to_up
    x = @height
    while x > 0
      count = 0
      y = @width
      while y > 0 && count < 3
        if @cimg.get_pixel(x, y) != 0
          @shape << [x,y]
          count += 1
        end
        y -= 1
      end
      x -= 1
    end
    # puts "d to u done!"
  end

  def verify_shape
    @shape = @shape.uniq
    # puts "removed duplicates!"
  end

end

#=================================================
