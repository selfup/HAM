require 'sinatra'
require 'json'
require 'pi_piper'

# using raspberry pi GPIO bottom row pins (left to right)
# GPIO pin numbers -> 2, 3, 4, 17, 27, 22, 10, 9

payload_to_pin_key = {
  "1" => 2,
  "2" => 3,
  "3" => 4,
  "4" => 17,
  "5" => 27,
  "6" => 22,
  "7" => 10,
  "8" => 9
}

pin_logic_gate = -> pins {
  pins.each { |k, v|
    pin = PiPiper::Pin.new(
      :pin => payload_to_pin_key[k],
      :direction => :out
    )
    return pin.on if v
    return pin.off if !v
  }
}

post '/' do
  payload = JSON.parse(request.body.read)
  pins = payload["pins"]
  pin_logic_gate(pins) if pins.keys.length == 8
end
