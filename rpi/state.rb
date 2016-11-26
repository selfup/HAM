@gpio_pins = {}

@app_pins = {
  18 => false,
  23 => false,
  24 => false,
  25 => false,
  12 => false,
  16 => false,
  20 => false,
  21 => false
}

@app_pins.each do |pin, v|
  @gpio_pins[pin] = PiPiper::Pin.new(pin: pin, direction: :out)
end
