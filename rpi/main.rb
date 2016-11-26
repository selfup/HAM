require 'socket'
require 'pi_piper'

@app_pins = {}

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

pin_logic_gate = -> pins do
  pins.each do |k, v|
    return @app_pins[k].on if v
    return @app_pins[k].off if !v
  end
end

@socket = TCPSocket.new('0.0.0.0', 5000)

loop do
  msg = @socket.recv(1000)
  puts msg
  pin_logic_gate.(@default_pins)
end
