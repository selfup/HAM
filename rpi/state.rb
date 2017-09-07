@gpio_pins = {}

@app_pins = {
  17 => false,
  27 => false,
  22 => false,
  23 => false,
  24 => false,
  25 => false,
  5 => false,
  6 => false
}

@app_pins.each do |pin, v|
  @gpio_pins[pin] = PiPiper::Pin.new(pin: pin, direction: :out)
end
