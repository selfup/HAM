require 'socket'
require 'pp'
require_relative './payload'

# parsing and transalation functions ##########################################
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
      if type[1] == "radio"
        {"slice" => e.values}
      else
        e.keys[0] = 0
      end
    end
    .select { |e| e != 0 }
}
# end of parsing functions ####################################################

@socket  ||= TCPSocket.new('10.0.0.18', 4992)
@payload ||= Payload.new

# start receiving all slices from flex on TCP socket
@socket.puts('c1|sub slice all')

# send default GPIO config to sinatra app
@payload.post

loop do
  msg = @socket.recv(1000)
  response = format_it.(msg)
  slices = tx_slices.(response)
  pp slices
  puts '-----------------------------------------------------------------------'
end
