require 'net/http'
require 'json'

class Post
  def initilize
    @http = Net::HTTP.new('10.0.0.230', 4567)
    @pins = default_pins
    request = Net::HTTP::Post.new('/')
    request.body = @pins.to_json
    response = http.request(request)
  end

  def default_pins
    {
      "pins" => {
        1 => true,
        2 => false
      }
    }
  end

  def new_pin_state(new_state)
    @pins = @pins.merge(new_state)
  end
end
