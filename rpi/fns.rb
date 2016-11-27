@print_or_close = -> msg, client do
  if msg == ""
    stream.close
  else
    @update_pins.(JSON.parse(msg), client)
  end
end

@update_pins = -> payload, client do
  if payload.keys.include?("17")
    keys = payload.keys.map { |e| e.to_i }
    translated_payload = Hash[keys.zip(payload.values)]
    @app_pins = @app_pins.merge(translated_payload)
    @pin_logic_gate.(@app_pins)
  end
end

@pin_logic_gate = -> pins do
  pins.each do |k, v|
    @gpio_pins[k].on if v
    @gpio_pins[k].off if !v
  end
  p @app_pins
end
