require 'socket'
require 'pp'

s = TCPSocket.new '10.0.0.18', 4992

format_it = -> msg {
  msg
    .dup
    .split("\n")
    .map { |e| e.split(' ') }
    .map { |e| key = e[0]; e.shift; {key => e} }
}

s.puts('c1|sub slice all')

loop do
  msg = s.recv(1000)
  s.write('c1|sub slice all')
  pp format_it.(msg)
  puts '-----------------------------------------------------------------------'
end
