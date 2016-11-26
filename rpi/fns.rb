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
  if payload.length > 0
    p "do something serious!!!"
  else
    p "tis empty: #{payload}"
  end
end
