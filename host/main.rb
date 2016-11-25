require 'socket'
require 'pp'
require_relative './payload'

@app_slices = {}

@valid_atennas = {
  "ANT2" => true
}

@atenna_payload_key = {
  "ANT2" => "0"
}

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
@payload = Payload.new

# start receiving all slices from flex on TCP socket
@socket.puts('c1|sub slice all')

# send default GPIO config to sinatra app
@payload.post

loop do
  msg = @socket.recv(1000)
  response = format_it.(msg)
  slices = tx_slices.(response)
  slice_formatter.(slices)
  pp @app_slices
  puts "\n------------------------------------\n\n"
end
