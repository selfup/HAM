require 'json'
require 'socket'
require 'pi_piper'

## state
require_relative './state'

## functions
require_relative './fns'

@pin_logic_gate.(@default_pins) # buid gpio_pins
socket_server = TCPServer.open(2000)

while true
  Thread.new(socket_server.accept) do |stream|
    puts "INBOUND TRAFFIC FROM: #{stream.peeraddr[2]}"
    loop do
      msg = stream.recvmsg
      @print_or_close.(msg[0])
    end
  end
end
