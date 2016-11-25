# for raspberry pi
# which pins needs to have current applied and/or removed

require 'sinatra'
require 'json'
require 'pi_piper'

post '/' do
  payload = JSON.parse(request.body.read)
  puts payload["pins"]
end