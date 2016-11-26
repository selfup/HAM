require 'socket'
require 'pi_piper'

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

@socket = TCPSocket.new('10.0.0.230', 4992)

loop do
  msg = @socket.recv(1000)
  puts msg
end
