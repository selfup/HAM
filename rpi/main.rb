require 'json'
require 'socket'
require 'pi_piper'
require 'pry'

## state
require_relative './state'

## functions
require_relative './fns'

@pin_logic_gate.(@app_pins)
@start_time = Time.now.utc
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
      ")
      loop do
        client.sendmsg("ON IT")
        msg = client.recvmsg
        @print_or_close.(msg[0], client)
        GC.start
      end
    end
  end

end
