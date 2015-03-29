require 'RMagick'

class Fractal < Magick::Image

  class Coords
    attr_accessor :lat, :long
    def initialize lat = 0, long = 0
      @lat = lat.to_f
      @long = long.to_f
    end
    def + other
      lat = self.lat + other.lat
      long = self.long + other.long
      return Coords.new(lat, long)
    end
    def - other
      lat = self.lat - other.lat
      long = self.long - other.long
      return Coords.new(lat, long)
    end
    def / number
      lat = self.lat / number
      long = self.long / number
      return Coords.new(lat, long)
    end
  end

  def initialize pixel_width = 2000, max_stack_level = 8
    super pixel_width, pixel_width
    @stack_level = 0
    @max_stack_level = max_stack_level
    li = pixel_width
    c1 = Coords.new(0,0)
    c2 = Coords.new(c1.lat + li, c1.long)
    c3 = Coords.new(c1.lat + li/2, c1.long + li * (3**0.5)/2)
    draw_triangle(c1, c2, c3)
    fill_triangle [[c1, c2, c3]]
    write("./fractal.jpg") {self.quality = 95}
    self.destroy!
  end

  def draw_triangle(s1, s2, s3)
    p = Magick::Draw.new
    p.stroke('#000000')
    p.stroke_width(1)
    p.fill('black')
    p.stroke_opacity('0.7')
    p.fill_opacity('0.07')
    p.polygon(s1.lat, s1.long, s2.lat, s2.long, s3.lat, s3.long)
    p.draw(self)
  end

  def fill_triangle array_of_triangles, init = false
    result_triangles = array_of_triangles.collect do |tr|
      s1, s2, s3 = tr[0], tr[1], tr[2]
      d1 = (s1 + s3)/2
      d2 = (s2 + s3)/2
      d3 = (s1 + s2)/2
      draw_triangle(d1,d2,d3)
      [[s1, d3, d1], [d3, s2, d2], [d1, d2, s3]]
    end
    return if (@stack_level += 1) > @max_stack_level
    fill_triangle result_triangles.flatten(1)
  end

end
