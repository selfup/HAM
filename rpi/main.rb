require 'json'
require 'socket'
require 'pi_piper'
## state
require_relative './state'
## functions
require_relative './fns'
@pin_logic_gate.(@app_pins)
## main
if __FILE__ == $0
  socket_server = TCPServer.open(2000)
  while true
    Thread.new(socket_server.accept) do |client|
      loop do
        @print_or_close.(client.recvmsg[0], client)
        puts "==="
        p Time.now.utc
        p @app_pins
        puts "==="
        GC.start
      end
    end
  end
end
