# this is a sinatra web server that lives on a raspberry pi
# it will receive a post request and then use pi_piper to turn on or off GPIO
require 'sinatra'
require 'json'
require 'pi_piper'

# using raspberry pi GPIO bottom row pins (left to right)
# GPIO pin numbers -> 2, 3, 4, 17, 27, 22, 10, 9

# translates payload keys to selected GPIO pins
payload_to_pin_key = {
  "1" => 15,
  "2" => 16,
  "3" => 18,
  "4" => 19,
  "5" => 21,
  "6" => 22,
  "7" => 23,
  "8" => 26
}

@pins = {}

%w(1 2 3 4 5 6 7 8).each do |pin|
  @pins[pin] = PiPiper::Pin.new(pin: payload_to_pin_key[pin], direction: :out)
end

# if respective key:value is set to true -> turn on GPIO pin
# if respective key:value is set to false -> turn off GPIO pin
pin_logic_gate = -> pins {
  pins.each { |k, v|
    return @pins[k].on if v
    return @pins[k].off if !v
  }
}

# handle host post request
# grab payload and translate using payload_to_pin_key
# once keys are translated -> send to parse gate to turn on or off GPIO pins
post '/' do
  payload = JSON.parse(request.body.read)
  pins = payload["pins"]
  pin_logic_gate.(pins)
end
