require 'json'
require 'socket'
require 'pi_piper'
require 'pry'

## state
require_relative './state'

## functions
require_relative './fns'

@pin_logic_gate.(@default_pins)
@start_time = Time.now
@connections = 0

## main
if __FILE__ == $0

  socket_server = TCPServer.open(2000)

  while true
    Thread.new(socket_server.accept) do |client|
      @connections += 1
      puts "INBOUND TRAFFIC FROM: #{client.peeraddr[2]}"
      client.sendmsg("
        CONNECTION ESTABLISHED
        YOUR CONNECTION NUMBER IS: #{@connections}
        THIS SERVER HAS BEEN UP SINCE: #{@start_time}
        THIS SERVER HAS HAD A TOTAL OF #{@connections} CONNECTIONS
      ")
      loop do
        msg = client.recvmsg
        puts msg
        @print_or_close.(msg[0])
      end
    end
  end

end
