# mruby-plato-spi-enzi   [![Build Status](https://travis-ci.org/mruby-plato/mruby-plato-spi-enzi.svg?branch=master)](https://travis-ci.org/mruby-plato/mruby-plato-spi-enzi)
Plato::SPI (Serial Peripheral Interface) class for enzi board
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

  # ... (snip) ...

  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-spi'
  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-spi-enzi'
end
```

## example
```ruby
spi = Plato::SPI.open(0)
puts spi.transfer(0)
```

## License
under the MIT License:
- see LICENSE file
