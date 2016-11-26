require 'json'
require 'socket'
require 'pi_piper'

## state
require_relative './state'

## functions
require_relative './fns'

@pin_logic_gate.(@default_pins)

## main
if __FILE__ == $0

  socket_server = TCPServer.open(2000)

  while true
    Thread.new(socket_server.accept) do |client|
      puts "INBOUND TRAFFIC FROM: #{client.peeraddr[2]}"
      loop do
        msg = client.recvmsg
        puts msg
        client.puts('message received')
        @print_or_close.(msg[0])
        client.puts('message parsed')
      end
    end
  end

end
