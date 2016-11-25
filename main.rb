require 'socket'
require 'pp'
require 'pi_piper'
require 'pry'

## state

@app_slices = {}
@app_pins = {}
@valid_atennas = {"ANT2" => true}
@atenna_payload_key = {"ANT2" => "0"}

default_pins = {
  15 => false,
  16 => false,
  18 => false,
  19 => false,
  21 => false,
  22 => false,
  23 => false,
  26 => false
}

default_pins.each do |pin, v|
  @app_pins[pin] = PiPiper::Pin.new(pin: pin, direction: :out)
end

## functions

format_it = -> msg do
  msg
    .dup
    .split("\n")
    .map { |e| e.split(' ') }
    .map do |e|
      key = e[0]
      e.shift
      {key => e}
    end
end

tx_slices = -> response do
  response
    .map do |e|
      type = e.keys[0].split('|')
      if type[1] == "slice"
        {"slice" => e.values[0]}
      else
        e.keys[0] = 0
      end
    end.select { |e| e != 0 }
end

app_state_updater = -> new_slice, new_values, slice_number do
  pre_format = new_slice
    .map { |e| e.split("=") }
    .each { |e| new_values[e[0]] = e[1] }

  if !@app_slices.keys.include?(slice_number)
    @app_slices[slice_number] = new_values
  else
    @app_slices[slice_number] = @app_slices[slice_number].merge(new_values)
  end
end

slice_formatter = -> slices do
  slices.map do |slice|
    new_values = {}
    new_slice = slice.values[0]
    slice_number = new_slice[0]
    new_slice.shift
    app_state_updater.(new_slice, new_values, slice_number)
  end
end

pin_logic_gate = -> pins do
  pins.each do |k, v|
    return @app_pins[k].on if v
    return @app_pins[k].off if !v
  end
end

read_and_update = -> msg do
  response = format_it.(msg)
  slices = tx_slices.(response)
  slice_formatter.(slices)
  pin_logic_gate.(default_pins)
end

## main

@socket = TCPSocket.new('10.0.0.18', 4992)
@socket.puts('c1|sub slice all')

loop do
  msg = @socket.recv(1000)
  read_and_update.(msg)
  puts Time.now
  puts "\n--------\n\n"
end
