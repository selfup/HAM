return puts "RPI ARMV7 ONLY"; exit if !RUBY_PLATFORM.include?("armv7l-linux")

require 'socket'
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
  @read_and_update.(msg)
  puts Time.now
  puts "\n--------\n\n"
end
