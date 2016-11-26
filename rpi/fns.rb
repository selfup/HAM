@pin_logic_gate = -> pins do
  pins.each do |k, v|
    @gpio_pins[k].on if v
    @gpio_pins[k].off if !v
  end
end

@print_or_close = -> msg, client do
  if msg == ""
    stream.close
  else
    @print_and_parse.(msg, client)
  end
end

@update_pins = -> payload, client do
  p payload.keys.include?("15")
  if !payload.keys.include?("15")
    p "DISCOVERED"
    client.sendmsg('hello!')
    client.sendmsg("another hello\n")
  elsif payload.keys.include?("15")
    p "PAYLOAD"
    p Time.now.utc
    keys = payload.keys.map { |e| e.to_i }
    values = payload.values.map do |e|
      p e
      if e == "0"
        false
      else
        true
      end
    end
    translated_payload = Hash[keys.zip(values)]
    @app_pins = @app_pins.merge(translated_payload)
    p @app_pins
  else
    p "WHAT JUST HAPPENED"
  end
end

@print_and_parse = -> msg, client do
  @update_pins.(JSON.parse(msg), client)
end
