@pin_logic_gate = -> pins do
  pins.each do |k, v|
    return @gpio_pins[k].on if v
    return @gpio_pins[k].off if !v
  end
end

@print_or_close = -> msg, client do
  if msg == ""
    sleep(1)
    stream.close
  else
    @print_and_parse.(msg, client)
  end
end

@print_and_parse = -> msg, client do
  @update_pins.(JSON.parse(msg, client))
end

@update_pins = -> payload, client do
  puts payload
  if payload.keys[0] == "hello"
    p "DISCOVERED"
    client.sendmsg('hello!')
  elsif payload.keys.include?("15")
    keys = payload.keys.map { |e| e.to_i }
    values = payload.values
    translated_payload = Hash[keys.zip(values)]
    @app_pins = @app_pins.merge(translated_payload)
    client.sendmsg("\n\nNEW PIN STATE: #{@app_pins.to_json}\n\n")
  else
    client.sendmsg("\n\nWhat was that?\n\n")
    p "WHAT JUST HAPPENED"
  end
end
