require 'socket'
require 'pp'
require 'pi_piper'

@app_slices = {}

@valid_atennas = {
  "ANT2" => true
}

@atenna_payload_key = {
  "ANT2" => "0"
}

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

@app_pins = {}

def default_pins
  {
    "pins" => {
      1 => false,
      2 => false,
      3 => false,
      4 => false,
      5 => false,
      6 => false,
      7 => false,
      8 => false
    }
  }
end

def new_pin_state(new_state)
  @pins = @pins.merge(new_state)
end

%w(1 2 3 4 5 6 7 8).each do |pin|
  @app_pins[pin] = PiPiper::Pin.new(
    pin: payload_to_pin_key[pin], direction: :out
  )
end

format_it = -> msg {
  msg
    .dup
    .split("\n")
    .map { |e| e.split(' ') }
    .map { |e| key = e[0]; e.shift; {key => e} }
}

tx_slices = -> response {
  response
    .map do |e|
      type = e.keys[0].split('|')
      if type[1] == "slice"
        {"slice" => e.values[0]}
      else
        e.keys[0] = 0
      end
    end
    .select { |e| e != 0 }
}

app_state_updater = -> new_slice, new_values, slice_number {
  pre_format = new_slice.map { |e| e.split("=") }
  pre_format.each { |e| new_values[e[0]] = e[1] }
  if !@app_slices.keys.include?(slice_number)
    @app_slices[slice_number] = new_values
  else
    @app_slices[slice_number] = @app_slices[slice_number].merge(new_values)
  end
}

slice_formatter = -> slices {
  slices.map do |slice|
    new_values = {}
    new_slice = slice.values[0]
    slice_number = new_slice[0]
    new_slice.shift
    app_state_updater.(new_slice, new_values, slice_number)
  end
}

@socket = TCPSocket.new('10.0.0.18', 4992)
@socket.puts('c1|sub slice all')

pin_logic_gate = -> pins {
  pins.each { |k, v|
    return @app_pins[k].on if v
    return @app_pins[k].off if !v
  }
}

loop do
  msg = @socket.recv(1000)
  response = format_it.(msg)
  slices = tx_slices.(response)
  slice_formatter.(slices)
  pp @app_slices
  pin_logic_gate(default_pins)
  puts "\n------------------------------------\n\n"
end
