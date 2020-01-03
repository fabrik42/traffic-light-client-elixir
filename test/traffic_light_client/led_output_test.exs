defmodule TrafficLightClient.LedOutputTest do
  use ExUnit.Case
  doctest TrafficLightClient.LedOutput

  alias TrafficLightClient.LedOutput

  test "new" do
    output = LedOutput.new(23)

    assert output.pin == 23
  end
end
