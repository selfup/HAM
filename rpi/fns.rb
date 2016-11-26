@pin_logic_gate = -> pins do
  pins.each do |k, v|
    return @gpio_pins[k].on if v
    return @gpio_pins[k].off if !v
  end
end

@print_or_close = -> msg do
  p "print or"
  p "message: #{msg}"
  if msg == ""
    sleep(1)
  else
    @print_and_parse.(msg)
  end
end

@update_pins = -> payload do
  p payload
  p "--------=-=-=-=-=-=-"
  if !payload.keys.include?("15")
    p "DISCOVERED"
  elsif payload.keys.include?("15")
    p "PAYLOAD"
    keys = payload.keys.map { |e| e.to_i }
    values = payload.values.map do |e|
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

@print_and_parse = -> msg do
  p "PARSING"
  @update_pins.(JSON.parse(msg))
end
