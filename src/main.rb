require 'socket'
require 'pp'
require 'pi_piper'
require 'pry'

## state

require_relative './state'

## functions

require_relative './fns'

## main

@socket = TCPSocket.new('10.0.0.18', 4992)
@socket.puts('c1|sub slice all')

loop do
  msg = @socket.recv(1000)
  read_and_update.(msg)
  puts Time.now
  puts "\n--------\n\n"
end
