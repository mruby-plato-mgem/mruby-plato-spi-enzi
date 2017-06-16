# PlatoEnzi::SPI class

OUTPUT = 1
module ENZI
  D10 = 10
  class SPI
    MSBFIRST = 0
    LSBFIRST = 1
    CLOCK_DIV4 = 4
    def initialize(bitodr, mode, clk); end
    def transfer(v); v; end
  end
  class DigitalIO
    def initialize(pin, io); end
    def high; end
    def low; end
  end
end

assert('SPI', 'class') do
  assert_equal(PlatoEnzi::SPI.class, Class)
end

assert('SPI', 'superclass') do
  assert_equal(PlatoEnzi::SPI.superclass, Object)
end

assert('SPI', 'new') do
  Plato::SPI.register_device(PlatoEnzi::SPI)
  s1 = Plato::SPI.open(0)
  s2 = Plato::SPI.open(1, 1)
  s3 = Plato::SPI.open(2, 1, :lsbfirst)
  s4 = Plato::SPI.open(3, 1, :msbfirst, 0)
  assert_true(s1 && s2 && s3 && s4)
end

assert('SPI', 'new - argument error') do
  assert_raise(ArgumentError) {PlatoEnzi::SPI.new}
  assert_raise(ArgumentError) {PlatoEnzi::SPI.new(1, ENZI::SPI::CLOCK_DIV4, :lsbfirst, 1, 2)}
  assert_raise(RangeError) {PlatoEnzi::SPI.new(-1)}
  assert_raise(RangeError) {PlatoEnzi::SPI.new(4)}
end

assert('SPI', 'transfer') do
  assert_nothing_raised {
    Plato::SPI.register_device(PlatoEnzi::SPI)
    spi = Plato::SPI.open(0)
    spi.transfer(1)
  }
end

assert('SPI', '_start/_end') do
  assert_nothing_raised {
    Plato::SPI.register_device(PlatoEnzi::SPI)
    spi = Plato::SPI.open(0)
    spi._start
    spi._end
  }
end
