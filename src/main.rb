require 'json'
require 'socket'
require 'pry'

## state
require_relative './state'

## functions
require_relative './fns'

## main
if __FILE__ == $0
  @start_time = Time.now


  # @flex_socket = TCPSocket.new('10.0.0.18', 4992)
  # @flex_socket.puts('c1|sub slice all')

  @pi_socket = TCPSocket.new('10.0.0.230', 2000)
  @pi_socket.write({hi: "hello"}.to_json)

  loop do
    # msg = @flex_socket.recv(1000)
    # @read_and_update.(msg)
    pi = @pi_socket.recvmsg
    puts pi[0]
    puts Time.now
    @pi_socket.write(@app_slices.to_json)
    puts "Current App Slices: \n\n #{@app_slices}"
    puts "\n--------\n\n"
  end

end
