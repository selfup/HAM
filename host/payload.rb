require 'net/http'
require 'json'
require 'pry'

class Payload
  def initialize
    @http ||= Net::HTTP.new('10.0.0.230', 4567)
    @pins = default_pins
  end

  def default_pins
    {
      "pins" => {
        1 => false,
        2 => false,
        3 => false,
        4 => false,
        5 => false,
        6 => false,
        7 => false,
        8 => false
      }
    }
  end

  def new_pin_state(new_state)
    @pins = @pins.merge(new_state)
  end

  def post
    request = Net::HTTP::Post.new('/')
    request.body = @pins.to_json
    response = @http.request(request)
  end
end
