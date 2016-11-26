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
  # @pi_socket.write({hi: "hello"}.to_json)

  loop do
    # READ AND PARSE FLEX MESSAGES
    msg = @flex_socket.recvmsg
    @read_and_update.(msg[0])

    # READ RPI MESSAGES AND SEND PAYLOAD
    pi = @pi_socket.recvmsg
    @pi_socket.write({"hello" => "hello"}.to_json)
    puts pi[0]

    # HOST STDOUT
    puts "\n--------\n\n"
    puts Time.now
    @pi_socket.write(@app_slices.to_json)
    puts "Current App Slices: \n\n #{@app_slices.keys}"
    puts "\n--------\n\n"
  end

end
