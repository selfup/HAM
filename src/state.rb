@app_slices = {}
@app_pins = {}
@valid_atennas = {"ANT2" => true}
@atenna_payload_key = {"ANT2" => "0"}

@default_pins = {
  15 => false,
  16 => false,
  18 => false,
  19 => false,
  21 => false,
  22 => false,
  23 => false,
  26 => false
}

@default_pins.each do |pin, v|
  @app_pins[pin] = PiPiper::Pin.new(pin: pin, direction: :out)
end