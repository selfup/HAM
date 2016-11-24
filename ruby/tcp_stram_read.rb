require 'socket'
require 'pp'

s = TCPSocket.new '10.0.0.18', 4992

format_it = -> (msg) {
  msg[0].split("\n")
  .map { |e| e.split(' ') }
  .map { |e| key = e[0]; e.shift; {key => e}; }
}

loop do
  msg = s.recvmsg
  pp format_it.(msg)
  puts '-----------------------------------------------------------------------'
end
