require 'json'
require 'socket'
require 'pi_piper'

@gpio_pins = {}

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
  @gpio_pins[pin] = PiPiper::Pin.new(pin: pin, direction: :out)
end

@pin_logic_gate = -> pins do
  pins.each do |k, v|
    return @gpio_pins[k].on if v
    return @gpio_pins[k].off if !v
  end
end

@print_or_close = -> msg do
  if msg == ""
    sleep(1)
    stream.close
  else
    @print_and_parse.(msg)
  end
end

@print_and_parse = -> msg do
  @update_pins.(JSON.parse(msg))
end

@update_pins = -> payload do
  if payload.length > 0
    p "do something serious!!!"
  else
    p "tis empty: #{payload}"
  end
end

@pin_logic_gate.(@default_pins) # buid gpio_pins
socket_server = TCPServer.open(2000)

while true
  Thread.new(socket_server.accept) do |stream|
    puts "INBOUND TRAFFIC FROM: #{stream.peeraddr[2]}"
    loop do
      msg = stream.recvmsg
      @print_or_close.(msg[0])
    end
  end
end
