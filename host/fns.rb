@format_it = -> msg do
  msg
    .dup
    .split("\n")
    .map { |e| e.split(' ') }
    .map do |e|
      key = e[0]
      e.shift
      {key => e}
    end
end

@tx_slices = -> response do
  response
    .map do |e|
      type = e.keys[0].split('|')
      if type[1] == "slice"
        {"slice" => e.values[0]}
      else
        e.keys[0] = 0
      end
    end.select { |e| e != 0 }
end

@app_state_updater = -> new_slice, new_values, slice_number do
  pre_format = new_slice
    .map { |e| e.split("=") }
    .each { |e| new_values[e[0]] = e[1] }

  if !@app_slices.keys.include?(slice_number)
    @app_slices[slice_number] = new_values
  else
    @app_slices[slice_number] = @app_slices[slice_number].merge(new_values)
  end
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

@slice_to_channel = -> slice, num do
  slice_antenna = slice["txant"]
  freq = slice["RF_frequency"].to_f

  if @valid_atennas[slice_antenna] && freq >= 3.5
    ant_to_gpio = @antenna_payload_key[slice_antenna]
    @payload[ant_to_gpio] = false
  elsif @valid_atennas[slice_antenna] && freq < 3.5
    ant_to_gpio = @antenna_payload_key[slice_antenna]
    @payload[ant_to_gpio] = true
  end

  p @payload
end

@run_slices = -> do
  if @app_slices.length > 0
    @app_slices.each do |slice_number, slice_info|
      if slice_info["tx"] == "1"
        @slice_to_channel.(slice_info, slice_number)
      end
    end
  end
end

@read_and_update = -> msg do
  response = @format_it.(msg)
  inbound_slices = @tx_slices.(response)
  @slice_formatter.(inbound_slices)
  @run_slices.()
end
