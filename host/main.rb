## libs
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
  loop do
    pi_socket = TCPSocket.new('10.0.0.230', 2000)
    msg = @flex_socket.recvmsg
    @read_and_update.(msg[0])
    pi_socket.write(@payload)
    pi_socket.write("")
    pi_socket.close
    p pi_socket.closed?
    puts "\n--------\n\n"
    puts Time.now
    puts "\n--------\n\n"
  end
end
