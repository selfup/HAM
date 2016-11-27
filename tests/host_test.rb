require_relative './test_helper'
require_relative './../host/main'

class MockPi
  def write(json)
    json
  end

  def close
    "closed"
  end
end

mock_pi = MockPi.new

host_tests = {
  host_vars: -> {
    VAR_TEST = Minitest::Test.new('host variables')

    p "it can load and read all instance_variables on main"
    VAR_TEST.assert(@read_and_update)
    VAR_TEST.assert(@format_it)
    VAR_TEST.assert(@tx_slices)
    VAR_TEST.assert(@slice_formatter)
    VAR_TEST.assert(@app_state_updater)
    VAR_TEST.assert(@run_slices)
    VAR_TEST.assert(@slice_to_channel)
    VAR_TEST.assert(@pi_logic)
    VAR_TEST.assert(@payload)
    VAR_TEST.assert(@valid_atennas)
    VAR_TEST.assert(@antenna_payload_key)
    VAR_TEST.assert(@app_slices)

    @test_output.(VAR_TEST)
  },
  host_lambdas: -> {
    HOST_FNS = Minitest::Test.new('host lamdbas')

    p "it formats all incoming messages into a pre-parse format"
    # the mock method 'close' returns 'closed' proving the 'pi_logic' lamdba
    # was called at the end of '@read_and_update'
    HOST_FNS.assert_equal(
      "closed", @read_and_update.("af|slice sfsf=43", mock_pi)
    )
    HOST_FNS.assert_equal(
      [{"af|slice"=>["sfsf=43"]}], @format_it.("af|slice sfsf=43")
    )

    p "it only formats and returns pre-parsed 'slices'"
    HOST_FNS.assert_equal(
      [], @tx_slices.(@format_it.("af|324 sfsf=43"))
    )
    HOST_FNS.assert_equal(
      [{"slice"=>["sfsf=43"]}], @tx_slices.(@format_it.("af|slice sfsf=43"))
    )

    p "it does a final format job on each slice for JSON payload prep"
    on_slice = "af|slice 3 tx=1 txant=ANT2 RF_frequency=3.12"
    expected = [{"tx"=>"1", "txant"=>"ANT2", "RF_frequency"=>"3.12"}]

    HOST_FNS.assert_equal(
      [], @slice_formatter.(@tx_slices.(@format_it.("af|324 sfsf=43")))
    )
    HOST_FNS.assert_equal(
      [{}], @slice_formatter.(@tx_slices.(@format_it.("af|slice sfsf=43")))
    )

    HOST_FNS.assert_equal(
      expected, @slice_formatter.(@tx_slices.(@format_it.(on_slice)))
    )
  },
  pin_state: -> {
    GPIO_PIN = Minitest::Test.new('host lamdbas')

    p "it ensures that the gpio 17 pin state is managed as should be"
    on_slice = "af|slice 3 tx=1 txant=ANT2 RF_frequency=3.12"

    state_payload = {
      17=>true,
      27=>false,
      22=>false,
      23=>false,
      24=>false,
      25=>false,
      5=>false,
      6=>false
    }

    off_state_payload = {
      17=>false,
      27=>false,
      22=>false,
      23=>false,
      24=>false,
      25=>false,
      5=>false,
      6=>false
    }

    off_slice_1 = "af|slice 3 tx=0 txant=ANT1 RF_frequency=3.88"
    off_slice_2 = "af|slice 3 tx=1 txant=ANT2 RF_frequency=3.59"

    change_slice_1 = "af|slice 3 tx=0 txant=ANT2 RF_frequency=1.2"
    change_slice_2 = "af|slice 3 tx=0 txant=ANT1 RF_frequency=1.2"

    GPIO_PIN.assert_equal("closed", @read_and_update.(off_slice_1, mock_pi))
    GPIO_PIN.assert_equal(off_state_payload, @payload)

    GPIO_PIN.assert_equal("closed", @read_and_update.(on_slice, mock_pi))
    GPIO_PIN.assert_equal(state_payload, @payload)

    GPIO_PIN.assert_equal("closed", @read_and_update.(off_slice_2, mock_pi))
    GPIO_PIN.assert_equal(off_state_payload, @payload)

    GPIO_PIN.assert_equal("closed", @read_and_update.(on_slice, mock_pi))
    GPIO_PIN.assert_equal(state_payload, @payload)

    # doesn't change state since tx is off
    GPIO_PIN.assert_equal("closed", @read_and_update.(change_slice_1, mock_pi))
    GPIO_PIN.assert_equal(state_payload, @payload)

    # doesn't change state since ANT2 is not the 'txant' is off
    GPIO_PIN.assert_equal("closed", @read_and_update.(change_slice_2, mock_pi))
    GPIO_PIN.assert_equal(state_payload, @payload)

    GPIO_PIN.assert_equal("closed", @read_and_update.(off_slice_2, mock_pi))
    GPIO_PIN.assert_equal(off_state_payload, @payload)

    @test_output.(GPIO_PIN)
  }
}

@run_tests.(host_tests)
