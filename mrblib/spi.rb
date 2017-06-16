#
# PlatoEnzi::SPI class
#
module PlatoEnzi
  class SPI
    include Plato::SPI

    # SPI.new(mode, clk, bitodr, ss)
    # Params
    #   mode    SPI mode number
    #     |mode|Clock Polarity|Clock Phase|Clock Edge|
    #     |  0 |      0       |     0     |     1    |
    #     |  1 |      0       |     1     |     0    |
    #     |  2 |      1       |     0     |     1    |
    #     |  3 |      1       |     1     |     0    |
    #   clk     Baudrate prescaler for SPI transmission
    #   bitodr  Bit order of transmission
    #     :msbfirst   MSB first
    #     :lsbfirst   LSB first
    #   ss      SS pin
    def initialize(mode, clk=nil, bitodr=:msbfirst, ss=ENZI::D10)
      raise RangeError.new "Specify mode value of 0..3" if mode < 0 || mode > 3
      clk = ENZI::SPI::CLOCK_DIV4 unless clk
      # puts "PlatoEnzi::SPI.new: mode=#{mode}, clk=#{clk}, bitodr=#{bitodr}, ss=#{ss}"
      bitorder = (bitodr == :msbfirst) ? ENZI::SPI::MSBFIRST : ENZI::SPI::LSBFIRST
      @spi = ENZI::SPI.new(bitorder, mode, clk)
      @ss = ENZI::DigitalIO.new(ss, OUTPUT) if ss
    end

    def transfer(data)
      @spi.transfer(data)
    end

    def _start
      @ss.low if @ss
    end

    def _end
      @ss.high if @ss
    end
  end
end

# register enzi device
Plato::SPI.register_device(PlatoEnzi::SPI)

=begin
#
# W5200 (for SPI test)
#
module PlatoDevice
  class W5200
    def initialize(mode, ss)
      @spi = Plato::SPI.open(mode, nil, :msbfirst, ss)
    end

    def mac=(addr)
      addr.each_with_index {|v, i|
        _write(0x0009 + i, v)
      }
    end

    def mac
      addr = []
      6.times {|i|
        addr << _read(0x0009 + i)
      }
      addr
    end

    # private

    # write to regisger
    def _write(reg, data)
      @spi._start
      @spi.transfer((reg & 0xff00) >> 8)
      @spi.transfer(reg & 0xff)
      @spi.transfer(0x80)  # Write
      @spi.transfer(0x01)  # 1byte
      @spi.transfer(data)
      @spi._end
    end

    # read from register
    def _read(reg)
      @spi._start
      @spi.transfer((reg & 0xff00) >> 8)
      @spi.transfer(reg & 0xff)
      @spi.transfer(0x00)  # Read
      @spi.transfer(0x01)  # 1byte
      v = @spi.transfer(0)
      @spi._end
      v
    end
  end
end
=end
