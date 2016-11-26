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
  puts "slice formatter"
  puts slices
  slices.map do |slice|
    new_values = {}
    new_slice = slice.values[0]
    slice_number = new_slice[0]
    new_slice.shift
    @app_state_updater.(new_slice, new_values, slice_number)
  end
end

@read_and_update = -> msg do
  puts 0
  response = @format_it.(msg)
  puts 1
  p response
  inbound_slices = @tx_slices.(response)
  puts 2
  puts "wowow #{inbound_slices.length}"
  @slice_formatter.(inbound_slices)
end
