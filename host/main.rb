require 'json'
require 'socket'
require 'pry'

## state
require_relative './state'

## functions
require_relative './fns'

## main
if __FILE__ == $0
  @flex_socket = TCPSocket.new('10.0.0.18', 4992)
  @flex_socket.puts('c1|sub slice all')

  @pi_socket = TCPSocket.new('10.0.0.230', 2000)
  # @pi_socket.write({"15" => "0"}.to_json)

  loop do
    # READ AND PARSE FLEX MESSAGES
    msg = @flex_socket.recvmsg
    @read_and_update.(msg[0], @pi_socket)

    # READ RPI MESSAGES AND SEND PAYLOAD

    # HOST STDOUT
    puts "\n--------\n\n"
    puts Time.now
    puts "Current App Slices: \n\n #{@app_slices.keys}"
    puts "\n--------\n\n"
  end

end
