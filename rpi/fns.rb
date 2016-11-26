@pin_logic_gate = -> pins do
  pins.each do |k, v|
    return @gpio_pins[k].on if v
    return @gpio_pins[k].off if !v
  end
end

@print_or_close = -> msg do
  if msg == ""
    sleep(1)
    stream.close
  else
    @print_and_parse.(msg)
  end
end

@print_and_parse = -> msg do
  @update_pins.(JSON.parse(msg))
end

@update_pins = -> payload do
  if payload.keys[0] == "hello"
    p "DISCOVERED"
  elsif payload.keys.include?("15")
    keys = payload.keys.map { |e| e.to_i }
    binding.pry
    values = payload.values
    translated_payload = Hash[keys.zip(values)]
    @app_pins = @app_pins.merge(translated_payload)
  else
    p "tis empty: #{payload}"
  end
end
