require 'socket'
require 'pi_piper'
require 'pry'

## state
require_relative './state'

## functions
require_relative './fns'

## main
@flex_socket = TCPSocket.new('10.0.0.18', 4992)
@flex_socket.puts('c1|sub slice all')

@pi_socket = TCPSocket.new('10.0.0.230', 4992)
@pi_socket.puts('hi')

loop do
  msg = @flex_socket.recv(1000)
  @read_and_update.(msg)
  puts Time.now
  puts "\n--------\n\n"
end
