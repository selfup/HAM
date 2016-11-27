require 'json'
require 'socket'

## state
require_relative './state'

## functions
require_relative './fns'

## main
if __FILE__ == $0
  @flex_socket = TCPSocket.new('10.0.0.18', 4992)
  @flex_socket.puts('c1|sub slice all')

  loop do
    pi_socket = TCPSocket.new('10.0.0.230', 2000)
    # READ AND PARSE FLEX MESSAGES
    msg = @flex_socket.recv(1000)

    # READ RPI MESSAGES AND SEND PAYLOAD
    @read_and_update.(msg, pi_socket)

    # HOST STDOUT
    puts Time.now
    puts "App Slices: \n\n #{@app_slices.keys} -- \n\n"
  end

end
