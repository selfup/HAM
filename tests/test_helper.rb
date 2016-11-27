require 'pry'
require 'minitest/test'

@test_output = -> constant {
  puts "\n\n"
  puts constant.name.upcase
  puts "Assertions: #{constant.assertions}"
  puts "Failures: #{constant.failures.length}"
  puts "end of test\n\n"
}

@run_tests = -> all {
  all.values.each { |e| e.() }
}

puts "Starting Tests\n\n"
