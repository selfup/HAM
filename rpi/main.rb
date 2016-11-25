# this is a sinatra web server that lives on a raspberry pi
# it will receive a post request and then use pi_piper to turn on or off GPIO
require 'sinatra'
require 'json'
require 'pi_piper'

# using raspberry pi GPIO bottom row pins (left to right)
# GPIO pin numbers -> 2, 3, 4, 17, 27, 22, 10, 9

# translates payload keys to selected GPIO pins
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

# if respective key:value is set to true -> turn on GPIO pin
# if respective key:value is set to false -> turn off GPIO pin
pin_logic_gate = -> pins {
  puts pins # just for simple debugging
  # pins.each { |k, v|
  #   # each pins key value pair from payload -> ex: {"1": true}
  #   # k means key here so: k -> "1"
  #   # v just means value here so: v -> true
  #   # this is referencing the default payload in: payload.rb
  #   pin = PiPiper::Pin.new(:pin => payload_to_pin_key[k], :direction => :out)
  #   return pin.on if v
  #   return pin.off if !v
  # }
}

binding.pry
# handle host post request
# grab payload and translate using payload_to_pin_key
# once keys are translated -> send to parse gate to turn on or off GPIO pins
post '/' do
  payload = JSON.parse(request.body.read)
  pins = payload["pins"]
  pin_logic_gate.(pins) if pins.keys.length == 8
end
