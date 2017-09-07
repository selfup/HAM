require 'json'
require 'socket'
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
    @read_and_update.(@flex_socket.recv(1000), pi_socket)
    puts "--------------------------------------"
    puts Time.now.utc
    puts @payload
    puts "App Slices: #{@app_slices.keys.length}"
    puts "--------------------------------------"
  end
end
