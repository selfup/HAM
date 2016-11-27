@read_and_update = -> msg, pi do
  response = @format_it.(msg)
  inbound_slices = @tx_slices.(response)
  @slice_formatter.(inbound_slices)
  @run_slices.()
  @pi_logic.(pi)
end

@format_it = -> msg do
  msg.dup.split("\n").map { |e| e.split(' ') }.map do |e|
    key = e[0]
    e.shift
    {key => e}
  end
end

@tx_slices = -> response do
  response.map do |e|
    if e.keys[0].split('|')[1] == "slice"
      {"slice" => e.values[0]}
    else
      e.keys[0] = 0
    end
  end.select { |e| e != 0 }
end

@slice_formatter = -> slices do
  slices.map do |slice|
    new_values = {}
    new_slice = slice.values[0]
    slice_number = new_slice[0]
    new_slice.shift
    @app_state_updater.(new_slice, new_values, slice_number)
  end
end

@app_state_updater = -> slice, values, num do
  pre_format = slice.map { |e| e.split("=") }.each { |e| values[e[0]] = e[1] }
  if !@app_slices.keys.include?(num)
    @app_slices[num] = values
  else
    @app_slices[num] = @app_slices[num].merge(values)
  end
end

@run_slices = -> do
  if @app_slices.length > 0
    @app_slices.each do |slice_number, slice_info|
      if slice_info["tx"] == "1"
        @slice_to_channel.(slice_info)
      end
    end
  end
end

@slice_to_channel = -> slice do
  slice_antenna = slice["txant"]
  freq = slice["RF_frequency"].to_f
  ant_to_gpio = @antenna_payload_key[slice_antenna]
  @payload[ant_to_gpio] = false if @valid_atennas[slice_antenna] && freq >= 3.5
  @payload[ant_to_gpio] = true if @valid_atennas[slice_antenna] && freq < 3.5
end

@pi_logic = -> pi do
  pi.write(@payload.dup.to_json)
  pi.close
end
