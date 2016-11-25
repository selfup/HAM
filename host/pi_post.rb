# from windows / mac / linux
# post request to raspberry pi

require 'net/http'
require 'json'

http = Net::HTTP.new('10.0.0.230', 4567)

pins = {
  "pins" => {
    1 => true,
    2 => false
  }
}

request = Net::HTTP::Post.new('/')
request.body =pins.to_json

response = http.request(request)
